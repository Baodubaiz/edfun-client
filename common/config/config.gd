extends Node
## App-wide settings (base URL, timeouts).

const REQUEST_TIMEOUT := 15.0

## TODO: set the real API domain before releasing.
const PROD_API_URL := "https://api.edfun.example"

## Desktop editor/debug run: BE on the same machine.
const DEV_DESKTOP_API_URL := "http://localhost:5236"

## Android emulator reaches the host machine via 10.0.2.2.
## On a real phone, change this to your PC's LAN IP, e.g. "http://192.168.1.10:5236".
const DEV_ANDROID_API_URL := "http://10.0.2.2:5236"

var api_base_url: String = ""


func _ready() -> void:
	api_base_url = _resolve_api_url()


func _resolve_api_url() -> String:
	if not OS.is_debug_build():
		return PROD_API_URL
	if OS.get_name() == "Android":
		return DEV_ANDROID_API_URL
	return DEV_DESKTOP_API_URL
