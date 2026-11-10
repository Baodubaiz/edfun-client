extends Node
## Navigation: hub screens (inside main.tscn) and entering/leaving games.

const MAIN_SCENE := "res://main.tscn"
const SCREENS := {
	"login": "res://modules/users/ui/login_screen.tscn",
	"register": "res://modules/users/ui/register_screen.tscn",
	"catalog": "res://modules/catalog/ui/catalog_screen.tscn",
}

var current_game: Dictionary = {}

var _host: Node = null ## main.gd, set by attach_host()
var _stack: Array[String] = []


func _ready() -> void:
	Session.logged_out.connect(func() -> void:
		if _host != null:
			reset_to("login"))


## Called by main.tscn every time it loads (app start, or coming back from a game).
func attach_host(host: Node) -> void:
	_host = host
	if _stack.is_empty():
		reset_to("catalog" if Session.is_logged_in() else "login")
	else:
		_show(_stack.back())


func go_to(screen: String) -> void:
	_stack.push_back(screen)
	_show(screen)


## Clears history, e.g. after login/logout so Back doesn't return to the old screen.
func reset_to(screen: String) -> void:
	_stack = [screen]
	_show(screen)


## Returns false when there is nothing to go back to (caller may quit the app).
func back() -> bool:
	if _stack.size() <= 1:
		return false
	_stack.pop_back()
	_show(_stack.back())
	return true


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


func _show(screen: String) -> void:
	_host.show_screen(load(SCREENS[screen]))


func _apply_orientation(orientation: String) -> void:
	match orientation:
		"landscape":
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
		"sensor":
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR)
		_:
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
