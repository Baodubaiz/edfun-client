extends Node
## Navigation: hub screens (inside main.tscn) with params, and entering/leaving games.
##
## A screen that needs params defines `func setup(params: Dictionary)`. It is called BEFORE the
## screen enters the tree, so store the params there and use them in _ready().

const MAIN_SCENE := "res://main.tscn"
const HOME := "home"
const SCREENS := {
	"login": "res://modules/auth/ui/login_screen.tscn",
	"register": "res://modules/auth/ui/register_screen.tscn",
	"home": "res://modules/catalog/ui/home_screen.tscn",
	"game_detail": "res://modules/catalog/ui/game_detail_screen.tscn",
	"explore": "res://modules/levels/ui/explore_screen.tscn",
	"profile": "res://modules/users/ui/profile_screen.tscn",
	"settings": "res://modules/settings/ui/settings_screen.tscn",
	"game_placeholder": "res://modules/play/ui/game_placeholder_screen.tscn",
}
## Screens shown with the bottom tab bar.
const TABS := ["home", "explore", "profile", "settings"]

var current_game: Dictionary = {}

var _host: Node = null ## main.gd, set by attach_host()
var _stack: Array[Dictionary] = [] ## [{ screen: String, params: Dictionary }]


func _ready() -> void:
	Session.logged_out.connect(func() -> void:
		if _host != null:
			reset_to(HOME))


## Called by main.tscn every time it loads (app start, or coming back from a game).
func attach_host(host: Node) -> void:
	_host = host
	if _stack.is_empty():
		reset_to(HOME)
	else:
		_show(_stack.back())


func go_to(screen: String, params: Dictionary = {}) -> void:
	_stack.push_back({ "screen": screen, "params": params })
	_show(_stack.back())


## Clears history (tab switch, login/logout) so Back doesn't return to the old screen.
func reset_to(screen: String, params: Dictionary = {}) -> void:
	_stack = [{ "screen": screen, "params": params }]
	_show(_stack.back())


## Returns false when there is nothing to go back to (caller may quit the app).
func back() -> bool:
	if _stack.size() <= 1:
		return false
	_stack.pop_back()
	_show(_stack.back())
	return true


## The ONLY way screens start playing. `level_id` is set when playing a custom level.
## Game bundled in res://games/<id> (GameRegistry) -> open it; otherwise -> placeholder screen.
## When a mini game gets integrated, nothing in the screens needs to change.
func play(game_id: String, level_id: String = "") -> void:
	Settings.vibrate()
	RecentService.new().add(game_id)

	var game: Dictionary = GameRegistry.get_game(game_id)
	if game.is_empty():
		go_to("game_placeholder", { "game_id": game_id, "level_id": level_id })
		return
	var launch := game.duplicate()
	launch["level_id"] = level_id
	open_game(launch)


func open_game(game: Dictionary) -> void:
	current_game = game
	_host = null
	_apply_orientation(game.get("orientation", "portrait"))
	get_tree().change_scene_to_file(game["main_scene"])


func exit_game() -> void:
	current_game = {}
	_apply_orientation("portrait")
	get_tree().change_scene_to_file(MAIN_SCENE)


func toast(message: String) -> void:
	if _host != null:
		_host.show_toast(message)


func set_loading(visible: bool) -> void:
	if _host != null:
		_host.set_loading(visible)


func _show(entry: Dictionary) -> void:
	var screen: String = entry["screen"]
	_host.show_screen(screen, load(SCREENS[screen]), entry["params"])


func _apply_orientation(orientation: String) -> void:
	match orientation:
		"landscape":
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
		"sensor":
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR)
		_:
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
