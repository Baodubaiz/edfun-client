extends Node
## Gamora SDK: the ONLY hub API a game may use.
##
## Register as autoload "GamoraSdk" in both the hub and every game project.
## - Standalone (game project run on its own): uses safe defaults, exit quits the app.
## - In hub: the hub calls attach(bridge) at startup and calls are forwarded to it.
##
## The source of truth is gamora-client/addons/gamora_sdk; game repos get a copy
## via gamora-client/tools/sync_games.ps1. Do not edit the copies.

## Bump when the API below changes in a breaking way. Games declare the version they need in game.json.
const SDK_VERSION := 1

const GUEST_PLAYER := { "id": "", "display_name": "Guest", "is_guest": true }

## Hub-provided object implementing: get_player() -> Dictionary, exit_to_hub() -> void
var _bridge: Object = null


## Called by the hub only.
func attach(bridge: Object) -> void:
	_bridge = bridge


func is_in_hub() -> bool:
	return _bridge != null


## { id: String, display_name: String, is_guest: bool }
func get_player() -> Dictionary:
	if _bridge == null:
		return GUEST_PLAYER.duplicate()
	return _bridge.get_player()


## Folder where a game stores its local save files. Created if missing.
## Always pass your own game id (same as the folder name and game.json "id").
func save_dir(game_id: String) -> String:
	var path := "user://games/%s/" % game_id
	DirAccess.make_dir_recursive_absolute(path)
	return path


## Leave the game. In the hub: back to the hub home. Standalone: quit the app.
func exit_to_hub() -> void:
	if _bridge == null:
		get_tree().quit()
		return
	_bridge.exit_to_hub()
