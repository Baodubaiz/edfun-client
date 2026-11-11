class_name Game
extends RefCounted
## A game listed in the hub (managed by the Publisher in the future).
## `id` is the same id used by res://games/<id>/game.json once the real game is integrated.

var id: String = ""
var name: String = ""
var description: String = ""
var category_id: String = ""
var thumbnail: String = "" ## res:// path (URL later). "" = generated colored tile.
var category: GameCategory = null ## resolved by CatalogService


static func from_dict(data: Dictionary) -> Game:
	var game := Game.new()
	game.id = str(data.get("id", ""))
	game.name = str(data.get("name", ""))
	game.description = str(data.get("description", ""))
	game.category_id = str(data.get("category_id", ""))
	game.thumbnail = str(data.get("thumbnail", ""))
	return game


func category_name() -> String:
	return category.name if category != null else ""


func color() -> Color:
	return category.color if category != null else HubColors.PRIMARY
