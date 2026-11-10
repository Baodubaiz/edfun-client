extends Control
## UI layer: reads inputs, shows results, navigates. Logic lives in UsersService.

var _users := UsersService.new()

@onready var _user_name: LineEdit = %UserName
@onready var _email: LineEdit = %Email
@onready var _display_name: LineEdit = %DisplayName
@onready var _password: LineEdit = %Password
@onready var _error: Label = %Error
@onready var _submit: Button = %RegisterButton


func _ready() -> void:
	_submit.pressed.connect(_on_submit)
	_password.text_submitted.connect(func(_text: String) -> void: _on_submit())
	%BackButton.pressed.connect(func() -> void: Router.back())


func _on_submit() -> void:
	_set_busy(true)
	var res: Dictionary = await _users.register(_user_name.text, _email.text, _password.text, _display_name.text)
	_set_busy(false)

	if not res.ok:
		_error.text = res.error
		return
	Router.toast("Tạo tài khoản thành công!")
	Router.reset_to("catalog")


func _set_busy(busy: bool) -> void:
	_submit.disabled = busy
	_error.text = ""
	Router.set_loading(busy)
