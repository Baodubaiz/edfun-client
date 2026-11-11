extends Control
## Explore: browse & search custom levels shared by other players, select one and play it.

var _levels := LevelsService.new()
var _query := ""
var _selected: CustomLevel = null
var _card_group := ButtonGroup.new()
var _request := 0

@onready var _search: SearchBar = %Search
@onready var _count: Label = %Count
@onready var _list: VBoxContainer = %LevelList
@onready var _empty: EmptyState = %Empty
@onready var _selected_bar: Control = %SelectedBar
@onready var _selected_name: Label = %SelectedName
@onready var _selected_meta: Label = %SelectedMeta
@onready var _selected_description: Label = %SelectedDescription


func _ready() -> void:
	_search.search_changed.connect(func(query: String) -> void:
		_query = query
		_refresh())
	%PlaySelected.pressed.connect(func() -> void:
		if _selected != null:
			Router.play(_selected.game_id, _selected.id))
	_select(null)
	_refresh()


func _refresh() -> void:
	_request += 1
	var request := _request
	var res: Dictionary = await _levels.get_levels(_query)
	if not is_inside_tree() or request != _request:
		return

	for child in _list.get_children():
		child.queue_free()
	_card_group = ButtonGroup.new()
	_card_group.allow_unpress = true
	_select(null)
	_empty.visible = false

	if not res.ok:
		_count.text = ""
		_empty.show_message("Không tải được level", res.error)
		return
	var levels: Array[CustomLevel] = res.data
	_count.text = "%d level" % levels.size()
	if levels.is_empty():
		if _query != "":
			_empty.show_message("Không tìm thấy level", "Thử tìm theo tên level, tên game hoặc người tạo.")
		else:
			_empty.show_message("Chưa có level nào", "Level do người chơi chia sẻ sẽ xuất hiện tại đây.")
	for level in levels:
		var card := LevelCard.new(level)
		card.button_group = _card_group
		card.toggled.connect(func(on: bool) -> void:
			if on:
				_select(level)
			elif _card_group.get_pressed_button() == null:
				_select(null)) # unselected (not just switched to another card)
		_list.add_child(card)


func _select(level: CustomLevel) -> void:
	_selected = level
	_selected_bar.visible = level != null
	if level == null:
		return
	_selected_name.text = level.name
	_selected_meta.text = "%s · bởi @%s" % [level.game.name, level.creator_name]
	_selected_description.text = level.description
