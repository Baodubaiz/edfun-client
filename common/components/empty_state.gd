class_name EmptyState
extends VBoxContainer
## Centered icon + title + message, for empty lists and "no results". Call show_message() to display.

const DEFAULT_ICON := preload("res://assets/icons/empty.svg")

var _icon := TextureRect.new()
var _title := Label.new()
var _message := Label.new()


func _init() -> void:
	alignment = ALIGNMENT_CENTER
	add_theme_constant_override("separation", 12)

	_icon.texture = DEFAULT_ICON
	_icon.custom_minimum_size = Vector2(96, 96)
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.size_flags_horizontal = SIZE_SHRINK_CENTER
	_icon.modulate = HubColors.TEXT_MUTED.lerp(HubColors.BG, 0.4)

	for label in [_title, _message]:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title.theme_type_variation = &"SectionLabel"
	_message.theme_type_variation = &"MutedLabel"

	add_child(_icon)
	add_child(_title)
	add_child(_message)


func show_message(title: String, message: String = "") -> void:
	_title.text = title
	_message.text = message
	_message.visible = message != ""
	visible = true
