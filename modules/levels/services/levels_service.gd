class_name LevelsService
extends RefCounted
## Custom levels shared by players (Explore). Currently reads LevelsMock; swap for an API later.
## Each level gets its Game resolved, so screens can show "which game this level belongs to".

var _catalog := CatalogService.new()


## `query` matches level name, game name or creator (case-insensitive). data: Array[CustomLevel]
func get_levels(query: String = "") -> Dictionary:
	var games_res: Dictionary = await _catalog.get_games()
	if not games_res.ok:
		return games_res

	var games_by_id := {}
	for game: Game in games_res.data:
		games_by_id[game.id] = game

	var needle := query.strip_edges().to_lower()
	var result: Array[CustomLevel] = []
	for data: Dictionary in LevelsMock.LEVELS:
		var level := CustomLevel.from_dict(data)
		level.game = games_by_id.get(level.game_id)
		if level.game == null:
			continue # its game is no longer in the hub
		if needle != "" and not _matches(level, needle):
			continue
		result.append(level)
	return ServiceResult.ok(result)


## data: CustomLevel
func get_level(id: String) -> Dictionary:
	var res: Dictionary = await get_levels()
	if not res.ok:
		return res
	for level: CustomLevel in res.data:
		if level.id == id:
			return ServiceResult.ok(level)
	return ServiceResult.fail("Không tìm thấy level.", 404)


func _matches(level: CustomLevel, needle: String) -> bool:
	return level.name.to_lower().contains(needle) \
		or level.game.name.to_lower().contains(needle) \
		or level.creator_name.to_lower().contains(needle)
