class_name CategoriesService
extends RefCounted
## Data access for game categories. Currently reads CategoriesMock; swap for an API later
## (return shape stays { ok, error, data } via ServiceResult).


## data: Array[GameCategory]
func get_categories() -> Dictionary:
	await ServiceResult.mock_delay()
	return ServiceResult.ok(list())


## Synchronous list, used by CatalogService to resolve each game's category.
func list() -> Array[GameCategory]:
	var result: Array[GameCategory] = []
	for data: Dictionary in CategoriesMock.CATEGORIES:
		result.append(GameCategory.from_dict(data))
	return result
