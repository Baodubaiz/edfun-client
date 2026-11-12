class_name GameCard
extends Button
## Game tile: tap -> Game Detail, "Chơi" -> Router.play.
## `compact` = small vertical tile for horizontal rows (Recently Played).

const PLAY_ICON := preload("res://assets/icons/play.svg")

var game: Game


func _init(p_game: Game, compact: bool = false) -> void:
	game = p_game
	theme_type_variation = &"CardButton"
	focus_mode = FOCUS_NONE
	mouse_filter = MOUSE_FILTER_PASS # let parent ScrollContainer drag-scroll
	pressed.connect(func() -> void: Router.go_to("game_detail", { "game_id": game.id }))
	if compact:
		_build_compact()
	else:
		_build_row()


func _build_row() -> void:
	custom_minimum_size = Vector2(0, 160)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	_fill(row, 16)

	var thumb := GameThumb.new(game)
	thumb.custom_minimum_size = Vector2(128, 128)
	thumb.size_flags_vertical = SIZE_SHRINK_CENTER
	row.add_child(thumb)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = SIZE_EXPAND_FILL
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 10)
	info.mouse_filter = MOUSE_FILTER_IGNORE
	info.add_child(_title_label())
	info.add_child(HubTheme.tag(game.category_name(), game.color()))
	row.add_child(info)

	var play := Button.new()
	play.text = "Chơi"
	play.icon = PLAY_ICON
	play.theme_type_variation = &"AccentButton"
	play.focus_mode = FOCUS_NONE
	play.size_flags_vertical = SIZE_SHRINK_CENTER
	play.custom_minimum_size = Vector2(0, 72)
	play.pressed.connect(func() -> void: Router.play(game.id))
	row.add_child(play)


func _build_compact() -> void:
	custom_minimum_size = Vector2(200, 260)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 6)
	_fill(column, 14)

	var thumb := GameThumb.new(game, 16, 52)
	thumb.custom_minimum_size = Vector2(0, 150)
	column.add_child(thumb)
	column.add_child(_title_label())

	var category := Label.new()
	category.text = game.category_name()
	category.theme_type_variation = &"MutedLabel"
	column.add_child(category)


func _title_label() -> Label:
	var label := Label.new()
	label.text = game.name
	label.theme_type_variation = &"CardTitleLabel"
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return label


## Adds `content` filling the card with `margin` padding. Content ignores the mouse so taps reach the card.
func _fill(content: Control, margin: int) -> void:
	content.mouse_filter = MOUSE_FILTER_IGNORE
	content.set_anchors_and_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, margin)
	add_child(content)
