class_name SafeArea
extends MarginContainer
## Keeps children away from notches, rounded corners and system bars on phones.


func _ready() -> void:
	get_viewport().size_changed.connect(_apply)
	_apply()


func _apply() -> void:
	var window_size := Vector2(DisplayServer.window_get_size())
	if window_size.x <= 0 or window_size.y <= 0:
		return
	var safe := Rect2(DisplayServer.get_display_safe_area())
	var scale := get_viewport_rect().size / window_size

	add_theme_constant_override("margin_left", int(max(safe.position.x, 0.0) * scale.x))
	add_theme_constant_override("margin_top", int(max(safe.position.y, 0.0) * scale.y))
	add_theme_constant_override("margin_right", int(max(window_size.x - safe.end.x, 0.0) * scale.x))
	add_theme_constant_override("margin_bottom", int(max(window_size.y - safe.end.y, 0.0) * scale.y))
