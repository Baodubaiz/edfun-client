class_name CustomLevel
extends RefCounted
## A level created and shared by a player. Always belongs to one game (game_id -> Game.id).

var id: String = ""
var name: String = ""
var description: String = ""
var game_id: String = ""
var creator_name: String = ""
var play_count: int = 0
var game: Game = null ## resolved by LevelsService


static func from_dict(data: Dictionary) -> CustomLevel:
	var level := CustomLevel.new()
	level.id = str(data.get("id", ""))
	level.name = str(data.get("name", ""))
	level.description = str(data.get("description", ""))
	level.game_id = str(data.get("game_id", ""))
	level.creator_name = str(data.get("creator_name", ""))
	level.play_count = int(data.get("play_count", 0))
	return level
