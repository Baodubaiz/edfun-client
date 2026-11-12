extends Control
## Profile: avatar, display name and basic info. Data: ProfileService (mock while not logged in).

var _profiles := ProfileService.new()
var _auth := AuthService.new()

@onready var _avatar: PanelContainer = %Avatar
@onready var _avatar_label: Label = %AvatarLabel
@onready var _display_name: Label = %DisplayName
@onready var _username: Label = %Username
@onready var _bio: Label = %Bio
@onready var _recent_count: Label = %RecentCount
@onready var _joined: Label = %Joined
@onready var _status: Label = %Status
@onready var _logout: Button = %LogoutButton


func _ready() -> void:
	_avatar.add_theme_stylebox_override("panel", HubTheme.box(HubColors.PRIMARY, 999))
	_avatar_label.add_theme_font_override("font", HubTheme.bold_font())
	_logout.pressed.connect(_auth.logout)
	_recent_count.text = str(RecentService.new().get_ids().size())

	var res: Dictionary = await _profiles.get_profile()
	if not is_inside_tree() or not res.ok:
		return
	var player: Player = res.data
	_avatar_label.text = HubTheme.initials(player.display_name)
	_display_name.text = player.display_name
	_username.text = "@" + player.username
	_bio.text = player.bio
	_bio.visible = player.bio != ""
	_joined.text = _format_month(player.joined_at)
	_status.text = "Khách (dữ liệu mẫu)" if player.is_guest else "Đã đăng nhập"
	_logout.visible = not player.is_guest


## "2026-03-14" -> "03/2026"
func _format_month(date: String) -> String:
	var parts := date.split("-")
	return "%s/%s" % [parts[1], parts[0]] if parts.size() >= 2 else "—"
