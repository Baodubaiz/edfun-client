class_name AuthService
extends RefCounted
## Logic layer: validates input, calls AuthApi, updates Session. No UI code here.
## Every method returns { ok: bool, error: String, ... } so screens only need to display the result.

var _api := AuthApi.new()


func login(user_name_or_email: String, password: String) -> Dictionary:
	var login := user_name_or_email.strip_edges()
	if login == "" or password == "":
		return ServiceResult.fail("Nhập username/email và mật khẩu.")

	var res: Dictionary = await _api.login(login, password)
	if res.ok:
		Session.start(res.data)
	return res


func register(user_name: String, email: String, password: String, display_name: String) -> Dictionary:
	user_name = user_name.strip_edges()
	email = email.strip_edges()
	if user_name == "" or email == "" or password == "":
		return ServiceResult.fail("Nhập đủ username, email và mật khẩu.")
	if password.length() < 8:
		return ServiceResult.fail("Mật khẩu tối thiểu 8 ký tự.")

	var res: Dictionary = await _api.register(user_name, email, password, display_name.strip_edges())
	if res.ok:
		Session.start(res.data)
	return res


func logout() -> void:
	Session.logout()
