class_name HubTheme
extends RefCounted
## Builds the hub Theme in code (applied once on main.tscn, inherited by every screen).
## Use `theme_type_variation` on nodes to pick a style:
##   Labels:  TitleLabel, SectionLabel, CardTitleLabel, MutedLabel
##   Buttons: (default = primary), AccentButton, SecondaryButton, ChipButton, CardButton, IconButton, NavButton
##   Panels:  Card, BottomBar

const RADIUS := 20
const FONT_SIZE := 26

static var _bold: FontVariation


static func build() -> Theme:
	var t := Theme.new()
	t.default_font_size = FONT_SIZE

	# --- Labels
	t.set_color("font_color", "Label", HubColors.TEXT)
	_label_variation(t, "TitleLabel", bold_font(), 44, HubColors.TEXT)
	_label_variation(t, "SectionLabel", bold_font(), 30, HubColors.TEXT)
	_label_variation(t, "CardTitleLabel", bold_font(), 28, HubColors.TEXT)
	_label_variation(t, "MutedLabel", null, 22, HubColors.TEXT_MUTED)

	# --- Buttons
	_button(t, "Button", HubColors.PRIMARY, HubColors.PRIMARY_DARK, HubColors.ON_COLOR, HubColors.ON_COLOR)
	t.set_font("font", "Button", bold_font())
	_button(t, "AccentButton", HubColors.ACCENT, HubColors.ACCENT_DARK, HubColors.ON_COLOR, HubColors.ON_COLOR)
	_button(t, "SecondaryButton", HubColors.SURFACE, HubColors.SURFACE_PRESSED, HubColors.TEXT, HubColors.TEXT, RADIUS, HubColors.BORDER)
	_button(t, "ChipButton", HubColors.SURFACE, HubColors.PRIMARY, HubColors.TEXT, HubColors.ON_COLOR, 999, HubColors.BORDER, 24, 12)
	t.set_font_size("font_size", "ChipButton", 22)
	_button(t, "IconButton", HubColors.SURFACE, HubColors.SURFACE_PRESSED, HubColors.TEXT, HubColors.TEXT, 999, HubColors.BORDER, 16, 16)
	for state in ["icon_normal_color", "icon_hover_color", "icon_pressed_color", "icon_hover_pressed_color", "icon_focus_color"]:
		t.set_color(state, "IconButton", HubColors.TEXT)

	# Whole-card buttons: toggled (selected) state uses the primary border.
	_button(t, "CardButton", HubColors.SURFACE, HubColors.SURFACE_PRESSED, HubColors.TEXT, HubColors.TEXT, 24, HubColors.BORDER, 0, 0)
	var selected := box(HubColors.PRIMARY_SOFT, 24, HubColors.PRIMARY)
	selected.set_border_width_all(3)
	t.set_stylebox("pressed", "CardButton", selected)
	t.set_stylebox("hover_pressed", "CardButton", selected)

	# Bottom tab bar items: icon on top, primary color when active.
	t.set_type_variation("NavButton", "Button")
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled", "focus"]:
		t.set_stylebox(state, "NavButton", StyleBoxEmpty.new())
	for state in ["font_color", "font_hover_color", "font_focus_color", "icon_normal_color", "icon_hover_color", "icon_focus_color"]:
		t.set_color(state, "NavButton", HubColors.TEXT_MUTED)
	for state in ["font_pressed_color", "font_hover_pressed_color", "icon_pressed_color", "icon_hover_pressed_color"]:
		t.set_color(state, "NavButton", HubColors.PRIMARY)
	t.set_font_size("font_size", "NavButton", 20)
	t.set_constant("icon_max_width", "NavButton", 44)
	t.set_constant("h_separation", "NavButton", 6)

	# --- Panels
	t.set_type_variation("Card", "PanelContainer")
	t.set_stylebox("panel", "Card", box(HubColors.SURFACE, 24, HubColors.BORDER, 28, 28))
	t.set_type_variation("BottomBar", "PanelContainer")
	var bar := box(HubColors.SURFACE, 0, Color.TRANSPARENT, 8, 8)
	bar.border_color = HubColors.BORDER
	bar.border_width_top = 2
	t.set_stylebox("panel", "BottomBar", bar)

	# --- Inputs
	t.set_stylebox("normal", "LineEdit", box(HubColors.SURFACE, RADIUS, HubColors.BORDER, 24, 18))
	var focus := box(Color.TRANSPARENT, RADIUS, HubColors.PRIMARY)
	t.set_stylebox("focus", "LineEdit", focus)
	t.set_stylebox("read_only", "LineEdit", box(HubColors.SURFACE_PRESSED, RADIUS, HubColors.BORDER, 24, 18))
	t.set_color("font_color", "LineEdit", HubColors.TEXT)
	t.set_color("font_placeholder_color", "LineEdit", HubColors.TEXT_MUTED)
	t.set_color("caret_color", "LineEdit", HubColors.PRIMARY)
	t.set_color("selection_color", "LineEdit", HubColors.PRIMARY_SOFT)
	t.set_color("clear_button_color", "LineEdit", HubColors.TEXT_MUTED)
	t.set_color("clear_button_color_pressed", "LineEdit", HubColors.PRIMARY)

	# Switches & sliders (Settings)
	var on := load("res://assets/icons/switch_on.svg") as Texture2D
	var off := load("res://assets/icons/switch_off.svg") as Texture2D
	for icon in ["checked", "checked_mirrored", "checked_disabled", "checked_disabled_mirrored"]:
		t.set_icon(icon, "CheckButton", on)
	for icon in ["unchecked", "unchecked_mirrored", "unchecked_disabled", "unchecked_disabled_mirrored"]:
		t.set_icon(icon, "CheckButton", off)
	for state in ["normal", "hover", "pressed", "hover_pressed", "focus"]:
		t.set_stylebox(state, "CheckButton", StyleBoxEmpty.new())
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color", "font_focus_color"]:
		t.set_color(state, "CheckButton", HubColors.TEXT)

	var grabber := load("res://assets/icons/grabber.svg") as Texture2D
	for icon in ["grabber", "grabber_highlight", "grabber_disabled"]:
		t.set_icon(icon, "HSlider", grabber)
	t.set_stylebox("slider", "HSlider", box(HubColors.BORDER, 6, Color.TRANSPARENT, 0, 4))
	t.set_stylebox("grabber_area", "HSlider", box(HubColors.PRIMARY, 6, Color.TRANSPARENT, 0, 4))
	t.set_stylebox("grabber_area_highlight", "HSlider", box(HubColors.PRIMARY, 6, Color.TRANSPARENT, 0, 4))

	# Thin, quiet scrollbars.
	t.set_stylebox("panel", "ScrollContainer", StyleBoxEmpty.new())
	for bar_type in ["VScrollBar", "HScrollBar"]:
		t.set_stylebox("scroll", bar_type, StyleBoxEmpty.new())
		t.set_stylebox("grabber", bar_type, box(HubColors.BORDER, 6, Color.TRANSPARENT, 3, 3))
		t.set_stylebox("grabber_highlight", bar_type, box(HubColors.TEXT_MUTED, 6, Color.TRANSPARENT, 3, 3))
		t.set_stylebox("grabber_pressed", bar_type, box(HubColors.TEXT_MUTED, 6, Color.TRANSPARENT, 3, 3))
	return t


## Rounded flat box. `border` with alpha 0 = no border.
static func box(bg: Color, radius: int = RADIUS, border: Color = Color.TRANSPARENT, pad_h: int = 0, pad_v: int = 0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(radius)
	style.corner_detail = 12
	if border.a > 0.0:
		style.border_color = border
		style.set_border_width_all(2)
	style.content_margin_left = pad_h
	style.content_margin_right = pad_h
	style.content_margin_top = pad_v
	style.content_margin_bottom = pad_v
	return style


static func bold_font() -> Font:
	if _bold == null:
		_bold = FontVariation.new()
		_bold.base_font = ThemeDB.fallback_font
		_bold.variation_embolden = 0.6
	return _bold


## Small pill label tinted with `color` (e.g. a game's category).
static func tag(text: String, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_stylebox_override("normal", box(color.lerp(Color.WHITE, 0.85), 999, Color.TRANSPARENT, 16, 6))
	label.add_theme_color_override("font_color", color.darkened(0.2))
	label.add_theme_font_size_override("font_size", 20)
	label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


## "Tap Rush" -> "TR". Used for generated thumbnails and avatars.
static func initials(text: String) -> String:
	var result := ""
	for word in text.split(" ", false).slice(0, 2):
		result += word.substr(0, 1)
	return result.to_upper()


static func _label_variation(t: Theme, type: String, font: Font, size: int, color: Color) -> void:
	t.set_type_variation(type, "Label")
	if font != null:
		t.set_font("font", type, font)
	t.set_font_size("font_size", type, size)
	t.set_color("font_color", type, color)


static func _button(t: Theme, type: String, bg: Color, bg_pressed: Color, font: Color, font_pressed: Color,
		radius: int = RADIUS, border: Color = Color.TRANSPARENT, pad_h: int = 28, pad_v: int = 16) -> void:
	if type != "Button":
		t.set_type_variation(type, "Button")
	var pressed_border := HubColors.PRIMARY if bg_pressed == HubColors.PRIMARY else border
	t.set_stylebox("normal", type, box(bg, radius, border, pad_h, pad_v))
	t.set_stylebox("hover", type, box(bg.lerp(bg_pressed, 0.35), radius, border, pad_h, pad_v))
	t.set_stylebox("pressed", type, box(bg_pressed, radius, pressed_border, pad_h, pad_v))
	t.set_stylebox("hover_pressed", type, box(bg_pressed, radius, pressed_border, pad_h, pad_v))
	t.set_stylebox("disabled", type, box(Color(bg, bg.a * 0.5), radius, border, pad_h, pad_v))
	t.set_stylebox("focus", type, StyleBoxEmpty.new())
	for state in ["font_color", "font_hover_color", "font_focus_color"]:
		t.set_color(state, type, font)
	for state in ["font_pressed_color", "font_hover_pressed_color"]:
		t.set_color(state, type, font_pressed)
	t.set_color("font_disabled_color", type, Color(font, 0.6))
