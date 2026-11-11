class_name GameThumb
extends PanelContainer
## Game artwork: the game's thumbnail if it exists, otherwise a tile in the category color with initials.


func _init(game: Game, radius: int = 20, font_size: int = 44) -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	add_theme_stylebox_override("panel", HubTheme.box(game.color(), radius))

	if game.thumbnail != "" and ResourceLoader.exists(game.thumbnail):
		clip_children = CLIP_CHILDREN_ONLY
		var image := TextureRect.new()
		image.texture = load(game.thumbnail)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		image.mouse_filter = MOUSE_FILTER_IGNORE
		add_child(image)
		return

	var label := Label.new()
	label.text = HubTheme.initials(game.name)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", HubTheme.bold_font())
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", HubColors.ON_COLOR)
	add_child(label)
