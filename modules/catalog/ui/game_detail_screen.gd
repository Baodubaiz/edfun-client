extends Control
## Game Detail. params: { game_id: String }

var _catalog := CatalogService.new()
var _game_id := ""

@onready var _content: VBoxContainer = %Content
@onready var _name: Label = %GameName
@onready var _tags: HBoxContainer = %Tags
@onready var _description: Label = %Description
@onready var _play: Button = %PlayButton
@onready var _footer: Control = %Footer
@onready var _not_found: EmptyState = %NotFound


func setup(params: Dictionary) -> void:
	_game_id = str(params.get("game_id", ""))


func _ready() -> void:
	%BackButton.pressed.connect(Router.back)
	_play.pressed.connect(func() -> void: Router.play(_game_id))
	_content.visible = false
	_footer.visible = false

	var res: Dictionary = await _catalog.get_game(_game_id)
	if not is_inside_tree():
		return
	if not res.ok:
		_not_found.show_message("Không tìm thấy game", "Game này có thể đã bị gỡ khỏi hub.")
		return

	var game: Game = res.data
	var thumb := GameThumb.new(game, 28, 120)
	thumb.custom_minimum_size = Vector2(0, 380)
	_content.add_child(thumb)
	_content.move_child(thumb, 0)
	_name.text = game.name
	_tags.add_child(HubTheme.tag(game.category_name(), game.color()))
	_description.text = game.description
	_content.visible = true
	_footer.visible = true
