class_name Player
extends RefCounted
## Public profile of a player.

var id: String = ""
var display_name: String = ""
var username: String = ""
var bio: String = ""
var joined_at: String = "" ## "YYYY-MM-DD"
var is_guest: bool = true ## true = mock/guest data, not a logged-in account


static func from_dict(data: Dictionary) -> Player:
	var player := Player.new()
	player.id = str(data.get("id", ""))
	player.display_name = str(data.get("display_name", ""))
	player.username = str(data.get("username", ""))
	player.bio = str(data.get("bio", ""))
	player.joined_at = str(data.get("joined_at", ""))
	player.is_guest = bool(data.get("is_guest", true))
	return player
