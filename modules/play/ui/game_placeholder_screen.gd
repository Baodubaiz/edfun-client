extends Control
## Shown by Router.play() when the game is not integrated yet. params: { game_id, level_id }
## Once a mini game is bundled in res://games/<id>, Router.play() opens it instead of this screen.

var _catalog := CatalogService.new()
var _levels := LevelsService.new()
var _game_id := ""
var _level_id := ""

@onready var _thumb_slot: CenterContainer = %ThumbSlot
@onready var _game_name: Label = %GameName
@onready var _level_info: Label = %LevelInfo


func setup(params: Dictionary) -> void:
	_game_id = str(params.get("game_id", ""))
	_level_id = str(params.get("level_id", ""))


func _ready() -> void:
	%BackButton.pressed.connect(Router.back)
	%HomeButton.pressed.connect(func() -> void: Router.reset_to(Router.HOME))
	_level_info.visible = false

	var game_res: Dictionary = await _catalog.get_game(_game_id)
	if not is_inside_tree():
		return
	if not game_res.ok:
		_game_name.text = "Game không xác định"
		return
	var game: Game = game_res.data
	_game_name.text = game.name
	var thumb := GameThumb.new(game, 32, 64)
	thumb.custom_minimum_size = Vector2(176, 176)
	_thumb_slot.add_child(thumb)

	if _level_id == "":
		return
	var level_res: Dictionary = await _levels.get_level(_level_id)
	if is_inside_tree() and level_res.ok:
		var level: CustomLevel = level_res.data
		_level_info.text = "Level: %s · bởi @%s" % [level.name, level.creator_name]
		_level_info.visible = true
