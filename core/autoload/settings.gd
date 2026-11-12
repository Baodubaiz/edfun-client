extends Node
## Device-only app settings, saved in user://settings.cfg. Applied at startup and on every change.

signal changed

const FILE := "user://settings.cfg"

var sound_enabled: bool = true
var volume: float = 0.8 ## 0..1
var vibration_enabled: bool = true


func _ready() -> void:
	_load()
	_apply()


func set_sound_enabled(value: bool) -> void:
	sound_enabled = value
	_commit()


func set_volume(value: float) -> void:
	volume = clampf(value, 0.0, 1.0)
	_commit()


func set_vibration_enabled(value: bool) -> void:
	vibration_enabled = value
	_commit()


## Short haptic tap (phones only). Respects the vibration setting.
func vibrate(duration_ms: int = 30) -> void:
	if vibration_enabled:
		Input.vibrate_handheld(duration_ms)


func _commit() -> void:
	_apply()
	_save()
	changed.emit()


func _apply() -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, not sound_enabled or volume <= 0.0)
	AudioServer.set_bus_volume_db(bus, linear_to_db(maxf(volume, 0.0001)))


func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "sound_enabled", sound_enabled)
	cfg.set_value("audio", "volume", volume)
	cfg.set_value("device", "vibration_enabled", vibration_enabled)
	var err := cfg.save(FILE)
	if err != OK:
		push_warning("Settings: cannot write %s (%s)" % [FILE, error_string(err)])


func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(FILE) != OK:
		return
	sound_enabled = cfg.get_value("audio", "sound_enabled", sound_enabled)
	volume = cfg.get_value("audio", "volume", volume)
	vibration_enabled = cfg.get_value("device", "vibration_enabled", vibration_enabled)
