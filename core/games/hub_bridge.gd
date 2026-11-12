extends RefCounted
## Hub-side implementation behind EdfunSdk. Games never reference this file directly.


func get_player() -> Dictionary:
	if not Session.is_logged_in():
		return EdfunSdk.GUEST_PLAYER.duplicate()
	return {
		"id": str(Session.user.get("id", "")),
		"display_name": str(Session.user.get("displayName", "")),
		"is_guest": false,
	}


func exit_to_hub() -> void:
	Router.exit_game()
