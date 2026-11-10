extends Control
## Root of the hub UI. Hosts the current screen plus global overlays (loading, toast).

const HubBridge := preload("res://common/sdk/hub_bridge.gd")

@onready var _screen_host: Control = %ScreenHost
@onready var _loading: Control = %Loading
@onready var _toast: Label = %Toast

var _toast_tween: Tween


func _ready() -> void:
	if not EdfunSdk.is_in_hub():
		EdfunSdk.attach(HubBridge.new())
	Router.attach_host(self)


func show_screen(scene: PackedScene) -> void:
	for child in _screen_host.get_children():
		child.queue_free()
	_screen_host.add_child(scene.instantiate())


func set_loading(visible: bool) -> void:
	_loading.visible = visible


func show_toast(message: String) -> void:
	_toast.text = message
	_toast.visible = true
	_toast.modulate.a = 1.0
	if _toast_tween:
		_toast_tween.kill()
	_toast_tween = create_tween()
	_toast_tween.tween_interval(2.0)
	_toast_tween.tween_property(_toast, "modulate:a", 0.0, 0.4)
	_toast_tween.tween_callback(func() -> void: _toast.visible = false)


## Android Back button (quit_on_go_back is disabled in project settings).
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and not Router.back():
		get_tree().quit()
