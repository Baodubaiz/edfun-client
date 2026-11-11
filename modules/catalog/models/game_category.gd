class_name GameCategory
extends RefCounted
## A game genre (Arcade, Puzzle, ...). `color` tints thumbnails and tags.

var id: String = ""
var name: String = ""
var color: Color = HubColors.PRIMARY


static func from_dict(data: Dictionary) -> GameCategory:
	var category := GameCategory.new()
	category.id = str(data.get("id", ""))
	category.name = str(data.get("name", ""))
	category.color = Color(str(data.get("color", HubColors.PRIMARY.to_html(false))))
	return category
