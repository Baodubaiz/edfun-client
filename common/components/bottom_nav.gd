class_name BottomNav
extends PanelContainer
## Bottom tab bar. setup() takes items: [{ "screen": String, "label": String, "icon": Texture2D }].

signal tab_selected(screen: String)

var _buttons: Dictionary = {} ## screen -> Button
var _group := ButtonGroup.new()


func setup(items: Array) -> void:
	theme_type_variation = &"BottomBar"
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	add_child(row)

	for item: Dictionary in items:
		var screen: String = item["screen"]
		var button := Button.new()
		button.theme_type_variation = &"NavButton"
		button.toggle_mode = true
		button.button_group = _group
		button.focus_mode = FOCUS_NONE
		button.text = item["label"]
		button.icon = item["icon"]
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.custom_minimum_size = Vector2(0, 104)
		button.pressed.connect(func() -> void: tab_selected.emit(screen))
		row.add_child(button)
		_buttons[screen] = button


## Highlights the tab without emitting tab_selected.
func select(screen: String) -> void:
	for key: String in _buttons:
		(_buttons[key] as Button).set_pressed_no_signal(key == screen)
