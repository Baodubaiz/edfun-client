extends Node
## Current login: access token + user profile. Persisted (encrypted) across app restarts.

signal logged_in(user: Dictionary)
signal logged_out

const SESSION_FILE := "user://session.dat"

var access_token: String = ""
var expires_at: int = 0 ## unix seconds (UTC)
var user: Dictionary = {}


func _ready() -> void:
	_load()


func is_logged_in() -> bool:
	return access_token != "" and Time.get_unix_time_from_system() < expires_at


## `auth` is the backend AuthResponse: { accessToken, expiresAt, user }.
func start(auth: Dictionary) -> void:
	access_token = auth.get("accessToken", "")
	expires_at = _parse_iso_utc(auth.get("expiresAt", ""))
	user = auth.get("user", {})
	_save()
	logged_in.emit(user)


func logout() -> void:
	access_token = ""
	expires_at = 0
	user = {}
	if FileAccess.file_exists(SESSION_FILE):
		DirAccess.remove_absolute(SESSION_FILE)
	logged_out.emit()


func _save() -> void:
	var file := FileAccess.open_encrypted_with_pass(SESSION_FILE, FileAccess.WRITE, _key())
	if file == null:
		push_warning("Session: cannot write %s (%s)" % [SESSION_FILE, error_string(FileAccess.get_open_error())])
		return
	file.store_var({ "access_token": access_token, "expires_at": expires_at, "user": user })


func _load() -> void:
	if not FileAccess.file_exists(SESSION_FILE):
		return
	var file := FileAccess.open_encrypted_with_pass(SESSION_FILE, FileAccess.READ, _key())
	if file == null:
		return
	var data: Variant = file.get_var()
	if data is Dictionary:
		access_token = data.get("access_token", "")
		expires_at = data.get("expires_at", 0)
		user = data.get("user", {})
	if not is_logged_in():
		access_token = ""
		user = {}


## Obfuscation only (keeps the token out of plain text). Use Android Keystore for real protection.
func _key() -> String:
	var device_id := OS.get_unique_id()
	return "edfun-session-" + (device_id if device_id != "" else "local")


## Backend sends e.g. "2026-11-10T09:00:00.1234567+00:00" (always UTC).
func _parse_iso_utc(value: String) -> int:
	if value.length() < 19:
		return 0
	return Time.get_unix_time_from_datetime_string(value.substr(0, 19))
