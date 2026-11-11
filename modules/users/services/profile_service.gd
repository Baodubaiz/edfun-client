class_name ProfileService
extends RefCounted
## Current player's profile. Uses the logged-in Session user when there is one, otherwise mock data.
## Later: replace the mock branch with UsersApi.me().


## data: Player
func get_profile() -> Dictionary:
	await ServiceResult.mock_delay()
	if Session.is_logged_in():
		return ServiceResult.ok(Player.from_dict({
			"id": str(Session.user.get("id", "")),
			"display_name": str(Session.user.get("displayName", "")),
			"username": str(Session.user.get("userName", "")),
			"joined_at": str(Session.user.get("createdAt", "")).substr(0, 10),
			"is_guest": false,
		}))
	return ServiceResult.ok(Player.from_dict(ProfileMock.PLAYER))
