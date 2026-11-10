extends Control
## UI layer: lists the games bundled in the app (from GameRegistry) and opens them.

var _users := UsersService.new()

@onready var _greeting: Label = %Greeting
@onready var _game_list: VBoxContainer = %GameList
@onready var _empty: Label = %Empty


func _ready() -> void:
	_greeting.text = "Xin chào, %s" % Session.user.get("displayName", "")
	%LogoutButton.pressed.connect(_users.logout)
	_render_games()


func _render_games() -> void:
	for child in _game_list.get_children():
		child.queue_free()

	_empty.visible = GameRegistry.games.is_empty()
	for game in GameRegistry.games:
		var button := Button.new()
		button.text = "%s   v%s" % [game["name"], game["version"]]
		button.custom_minimum_size = Vector2(0, 120)
		button.add_theme_font_size_override("font_size", 32)
		button.pressed.connect(Router.open_game.bind(game))
		_game_list.add_child(button)
