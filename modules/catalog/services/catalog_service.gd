class_name CatalogService
extends RefCounted
## Data access for games & categories. Currently reads CatalogMock.
## To use the backend later, replace the method bodies with CatalogApi calls; the return shape
## ({ ok, error, data } via ServiceResult) stays the same, so screens don't change.


func get_categories() -> Dictionary:
	await ServiceResult.mock_delay()
	return ServiceResult.ok(_categories())


## Search + filter. `query` matches the game name (case-insensitive); `category_id` "" = all.
## data: Array[Game]
func get_games(query: String = "", category_id: String = "") -> Dictionary:
	await ServiceResult.mock_delay()
	var needle := query.strip_edges().to_lower()
	var result: Array[Game] = []
	for game: Game in _games():
		if category_id != "" and game.category_id != category_id:
			continue
		if needle != "" and not game.name.to_lower().contains(needle):
			continue
		result.append(game)
	return ServiceResult.ok(result)


## data: Game
func get_game(id: String) -> Dictionary:
	await ServiceResult.mock_delay()
	for game: Game in _games():
		if game.id == id:
			return ServiceResult.ok(game)
	return ServiceResult.fail("Không tìm thấy game.", 404)


## Recently played games, newest first. data: Array[Game]
func get_recent_games() -> Dictionary:
	await ServiceResult.mock_delay()
	var by_id := {}
	for game: Game in _games():
		by_id[game.id] = game
	var result: Array[Game] = []
	for id in RecentService.new().get_ids():
		if by_id.has(id):
			result.append(by_id[id])
	return ServiceResult.ok(result)


func _categories() -> Array[GameCategory]:
	var list: Array[GameCategory] = []
	for data: Dictionary in CatalogMock.CATEGORIES:
		list.append(GameCategory.from_dict(data))
	return list


func _games() -> Array[Game]:
	var categories := {}
	for category: GameCategory in _categories():
		categories[category.id] = category
	var list: Array[Game] = []
	for data: Dictionary in CatalogMock.GAMES:
		var game := Game.from_dict(data)
		game.category = categories.get(game.category_id)
		list.append(game)
	return list
