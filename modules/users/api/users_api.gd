class_name UsersApi
extends RefCounted
## API layer: HTTP calls to the backend Users module (/api/users/me). No validation, no UI.


func me() -> Dictionary:
	return await Api.get_json("/api/users/me")
