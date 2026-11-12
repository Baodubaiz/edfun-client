extends Control
## Root of the hub UI. Hosts the current screen, the bottom tab bar and global overlays (loading, toast).

const HubBridge := preload("res://core/routing/hub_bridge.gd")
const TRANSITION_TIME := 0.2

@onready var _screen_host: Control = %ScreenHost
@onready var _bottom_nav: BottomNav = %BottomNav
@onready var _loading: Control = %Loading
@onready var _toast: Label = %Toast

var _toast_tween: Tween


func _ready() -> void:
	theme = HubTheme.build()
	_style_overlays()
	# Tabs: [{ "screen": String, "label": String, "icon": Texture2D }], one per Router.TABS entry.
	_bottom_nav.setup([])
	_bottom_nav.visible = not Router.TABS.is_empty()
	_bottom_nav.tab_selected.connect(func(screen: String) -> void: Router.reset_to(screen))

	if not EdfunSdk.is_in_hub():
		EdfunSdk.attach(HubBridge.new())
	Router.attach_host(self)


func show_screen(screen_name: String, scene: PackedScene, params: Dictionary) -> void:
	for child in _screen_host.get_children():
		child.queue_free()

	var screen := scene.instantiate() as Control
	if screen.has_method("setup"):
		screen.setup(params)
	screen.modulate.a = 0.0
	_screen_host.add_child(screen)

	var is_tab := Router.TABS.has(screen_name)
	_bottom_nav.visible = is_tab
	if is_tab:
		_bottom_nav.select(screen_name)

	# Fade + short slide in.
	screen.position.x = 40.0
	var tween := screen.create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(screen, "modulate:a", 1.0, TRANSITION_TIME)
	tween.tween_property(screen, "position:x", 0.0, TRANSITION_TIME)


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


func _style_overlays() -> void:
	(_loading as ColorRect).color = HubColors.OVERLAY
	%LoadingLabel.add_theme_color_override("font_color", HubColors.ON_COLOR)
	_toast.add_theme_stylebox_override("normal", HubTheme.box(HubColors.TEXT, 24, Color.TRANSPARENT, 28, 18))
	_toast.add_theme_color_override("font_color", HubColors.ON_COLOR)


## Android Back button (quit_on_go_back is disabled in project settings).
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and not Router.back():
		get_tree().quit()
