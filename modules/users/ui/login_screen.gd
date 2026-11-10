extends Control
## UI layer: reads inputs, shows results, navigates. Logic lives in UsersService.

var _users := UsersService.new()

@onready var _login: LineEdit = %UserNameOrEmail
@onready var _password: LineEdit = %Password
@onready var _error: Label = %Error
@onready var _submit: Button = %LoginButton


func _ready() -> void:
	_submit.pressed.connect(_on_submit)
	_password.text_submitted.connect(func(_text: String) -> void: _on_submit())
	%GoRegisterButton.pressed.connect(func() -> void: Router.go_to("register"))


func _on_submit() -> void:
	_set_busy(true)
	var res: Dictionary = await _users.login(_login.text, _password.text)
	_set_busy(false)

	if not res.ok:
		_error.text = res.error
		return
	Router.reset_to("catalog")


func _set_busy(busy: bool) -> void:
	_submit.disabled = busy
	_error.text = ""
	Router.set_loading(busy)
