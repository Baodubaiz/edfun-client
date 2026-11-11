class_name RecentService
extends RefCounted
## Recently played game ids, stored on the device (user://recent.cfg), newest first.

const FILE := "user://recent.cfg"
const MAX_ITEMS := 10


func get_ids() -> PackedStringArray:
	var cfg := ConfigFile.new()
	if cfg.load(FILE) != OK:
		return PackedStringArray()
	return cfg.get_value("recent", "game_ids", PackedStringArray())


func add(game_id: String) -> void:
	var ids := get_ids()
	var index := ids.find(game_id)
	if index >= 0:
		ids.remove_at(index)
	ids.insert(0, game_id)
	if ids.size() > MAX_ITEMS:
		ids.resize(MAX_ITEMS)

	var cfg := ConfigFile.new()
	cfg.set_value("recent", "game_ids", ids)
	var err := cfg.save(FILE)
	if err != OK:
		push_warning("RecentService: cannot write %s (%s)" % [FILE, error_string(err)])


func clear() -> void:
	if FileAccess.file_exists(FILE):
		DirAccess.remove_absolute(FILE)
