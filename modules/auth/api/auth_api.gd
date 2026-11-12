class_name AuthApi
extends RefCounted
## API layer: HTTP calls for login/register (backend Auth module, routes /api/users/*). No validation, no UI.


func login(user_name_or_email: String, password: String) -> Dictionary:
	return await Api.post_json("/api/users/login", {
		"userNameOrEmail": user_name_or_email,
		"password": password,
	})


func register(user_name: String, email: String, password: String, display_name: String) -> Dictionary:
	return await Api.post_json("/api/users/register", {
		"userName": user_name,
		"email": email,
		"password": password,
		"displayName": display_name,
	})
