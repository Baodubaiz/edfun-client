class_name LevelCard
extends Button
## Custom level row: level name, its game and its creator. Tap = select (toggle), "Chơi" = play it.

const PLAY_ICON := preload("res://assets/icons/play.svg")

var level: CustomLevel


func _init(p_level: CustomLevel) -> void:
	level = p_level
	theme_type_variation = &"CardButton"
	toggle_mode = true
	focus_mode = FOCUS_NONE
	mouse_filter = MOUSE_FILTER_PASS
	custom_minimum_size = Vector2(0, 152)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	row.mouse_filter = MOUSE_FILTER_IGNORE
	row.set_anchors_and_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, 16)
	add_child(row)

	var thumb := GameThumb.new(level.game, 16, 36)
	thumb.custom_minimum_size = Vector2(112, 112)
	thumb.size_flags_vertical = SIZE_SHRINK_CENTER
	row.add_child(thumb)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = SIZE_EXPAND_FILL
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 6)
	info.mouse_filter = MOUSE_FILTER_IGNORE
	info.add_child(_label(level.name, &"CardTitleLabel"))
	info.add_child(_label(level.game.name, &"MutedLabel", level.game.color().darkened(0.2)))
	info.add_child(_label("bởi @%s · %d lượt chơi" % [level.creator_name, level.play_count], &"MutedLabel"))
	row.add_child(info)

	var play := Button.new()
	play.text = "Chơi"
	play.icon = PLAY_ICON
	play.theme_type_variation = &"AccentButton"
	play.focus_mode = FOCUS_NONE
	play.size_flags_vertical = SIZE_SHRINK_CENTER
	play.custom_minimum_size = Vector2(0, 72)
	play.pressed.connect(func() -> void: Router.play(level.game_id, level.id))
	row.add_child(play)


func _label(text: String, variation: StringName, color: Color = Color.TRANSPARENT) -> Label:
	var label := Label.new()
	label.text = text
	label.theme_type_variation = variation
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	if color.a > 0.0:
		label.add_theme_color_override("font_color", color)
	return label
