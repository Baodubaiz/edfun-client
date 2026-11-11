extends Control
## Settings: device-only options (stored by the Settings autoload). Nothing here needs the backend.

@onready var _sound: CheckButton = %SoundToggle
@onready var _volume: HSlider = %VolumeSlider
@onready var _volume_label: Label = %VolumeLabel
@onready var _vibration: CheckButton = %VibrationToggle


func _ready() -> void:
	_sound.button_pressed = Settings.sound_enabled
	_volume.value = roundf(Settings.volume * 100.0)
	_vibration.button_pressed = Settings.vibration_enabled
	_update_volume_ui()

	_sound.toggled.connect(func(on: bool) -> void:
		Settings.set_sound_enabled(on)
		_update_volume_ui())
	_volume.value_changed.connect(func(value: float) -> void:
		Settings.set_volume(value / 100.0)
		_update_volume_ui())
	_vibration.toggled.connect(func(on: bool) -> void:
		Settings.set_vibration_enabled(on)
		if on:
			Settings.vibrate())
	%ClearRecentButton.pressed.connect(func() -> void:
		RecentService.new().clear()
		Router.toast("Đã xóa lịch sử chơi gần đây"))
	%VersionLabel.text = "Phiên bản %s" % ProjectSettings.get_setting("application/config/version", "0.1.0")


func _update_volume_ui() -> void:
	_volume.editable = Settings.sound_enabled
	_volume_label.text = "Âm lượng: %d%%" % int(_volume.value)
	_volume_label.modulate.a = 1.0 if Settings.sound_enabled else 0.5
