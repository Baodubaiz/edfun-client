class_name SearchBar
extends LineEdit
## Rounded search input with a search icon. Emits `search_changed` with the trimmed text.

signal search_changed(query: String)

const ICON := preload("res://assets/icons/search.svg")


func _ready() -> void:
	if placeholder_text == "":
		placeholder_text = "Tìm kiếm..."
	right_icon = ICON
	clear_button_enabled = true
	custom_minimum_size = Vector2(0, 84)
	text_changed.connect(func(value: String) -> void: search_changed.emit(value.strip_edges()))
