extends Control
## Home: search by name, filter by category, recently played and all games. Data: CatalogService.

var _catalog := CatalogService.new()
var _profiles := ProfileService.new()
var _query := ""
var _category_id := "" ## "" = all
var _chip_group := ButtonGroup.new()
var _request := 0 ## latest games request; older results are ignored

@onready var _greeting: Label = %Greeting
@onready var _search: SearchBar = %Search
@onready var _categories: HBoxContainer = %Categories
@onready var _recent_section: Control = %RecentSection
@onready var _recent_list: HBoxContainer = %RecentList
@onready var _recent_scroll: Control = %RecentScroll
@onready var _recent_empty: Label = %RecentEmpty
@onready var _list_title: Label = %ListTitle
@onready var _game_list: VBoxContainer = %GameList
@onready var _empty: EmptyState = %Empty


func _ready() -> void:
	_search.search_changed.connect(func(query: String) -> void:
		_query = query
		_refresh_games())
	_load_greeting()
	_load_categories()
	_load_recent()
	_refresh_games()


func _load_greeting() -> void:
	var res: Dictionary = await _profiles.get_profile()
	if is_inside_tree() and res.ok:
		_greeting.text = "Xin chào, %s" % (res.data as Player).display_name


func _load_categories() -> void:
	var res: Dictionary = await _catalog.get_categories()
	if not is_inside_tree() or not res.ok:
		return
	_add_chip("", "Tất cả")
	for category: GameCategory in res.data:
		_add_chip(category.id, category.name)


func _add_chip(id: String, label: String) -> void:
	var chip := Button.new()
	chip.text = label
	chip.theme_type_variation = &"ChipButton"
	chip.toggle_mode = true
	chip.button_group = _chip_group
	chip.button_pressed = id == _category_id
	chip.focus_mode = FOCUS_NONE
	chip.mouse_filter = MOUSE_FILTER_PASS
	chip.custom_minimum_size = Vector2(0, 64)
	chip.pressed.connect(func() -> void:
		_category_id = id
		_refresh_games())
	_categories.add_child(chip)


func _load_recent() -> void:
	var res: Dictionary = await _catalog.get_recent_games()
	if not is_inside_tree() or not res.ok:
		return
	var games: Array[Game] = res.data
	_recent_scroll.visible = not games.is_empty()
	_recent_empty.visible = games.is_empty()
	for game in games:
		_recent_list.add_child(GameCard.new(game, true))


func _refresh_games() -> void:
	_request += 1
	var request := _request
	var res: Dictionary = await _catalog.get_games(_query, _category_id)
	if not is_inside_tree() or request != _request:
		return

	for child in _game_list.get_children():
		child.queue_free()
	var filtering := _query != "" or _category_id != ""
	_recent_section.visible = not filtering
	_list_title.text = "Kết quả" if filtering else "Tất cả game"
	_empty.visible = false

	if not res.ok:
		_empty.show_message("Không tải được danh sách game", res.error)
		return
	var games: Array[Game] = res.data
	if games.is_empty():
		if filtering:
			_empty.show_message("Không tìm thấy game", "Thử từ khóa khác hoặc chọn thể loại khác.")
		else:
			_empty.show_message("Chưa có game nào", "Các game mới sẽ sớm xuất hiện tại đây.")
	for game in games:
		_game_list.add_child(GameCard.new(game))
