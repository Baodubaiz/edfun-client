extends Node
## Lists the games bundled in the app by reading res://games/<id>/game.json.

const GAMES_DIR := "res://games"
const REQUIRED_KEYS := ["id", "name", "version", "main_scene", "sdk_version"]

var games: Array[Dictionary] = []


func _ready() -> void:
	reload()


func reload() -> void:
	games.clear()
	var dir := DirAccess.open(GAMES_DIR)
	if dir == null:
		return

	for folder in dir.get_directories():
		var game := _read_manifest("%s/%s/game.json" % [GAMES_DIR, folder])
		if game.is_empty():
			continue
		if game["id"] != folder:
			push_warning("GameRegistry: '%s' has id '%s' (must match folder name), skipped." % [folder, game["id"]])
			continue
		if int(game["sdk_version"]) > EdfunSdk.SDK_VERSION:
			push_warning("GameRegistry: '%s' needs SDK v%s, hub has v%d, skipped." % [folder, game["sdk_version"], EdfunSdk.SDK_VERSION])
			continue
		games.append(game)

	games.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["name"] < b["name"])


func get_game(id: String) -> Dictionary:
	for game in games:
		if game["id"] == id:
			return game
	return {}


func _read_manifest(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not data is Dictionary:
		push_warning("GameRegistry: invalid JSON in %s" % path)
		return {}
	for key in REQUIRED_KEYS:
		if not data.has(key):
			push_warning("GameRegistry: %s is missing '%s'" % [path, key])
			return {}
	return data
