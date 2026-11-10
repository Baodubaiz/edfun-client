extends Node
## HTTP client for the Edfun backend.
## Every call returns: { ok: bool, status: int, data: Variant, error: String }


func get_json(path: String) -> Dictionary:
	return await request(HTTPClient.METHOD_GET, path)


func post_json(path: String, body: Dictionary) -> Dictionary:
	return await request(HTTPClient.METHOD_POST, path, body)


func request(method: HTTPClient.Method, path: String, body: Variant = null) -> Dictionary:
	var http := HTTPRequest.new()
	http.timeout = Config.REQUEST_TIMEOUT
	add_child(http)

	var headers := PackedStringArray(["Accept: application/json"])
	var payload := ""
	if body != null:
		headers.append("Content-Type: application/json")
		payload = JSON.stringify(body)
	if Session.access_token != "":
		headers.append("Authorization: Bearer " + Session.access_token)

	var err := http.request(Config.api_base_url + path, headers, method, payload)
	if err != OK:
		http.queue_free()
		return _fail(0, "Không gửi được yêu cầu (%s)." % error_string(err))

	var response: Array = await http.request_completed
	http.queue_free()

	var result: int = response[0]
	var status: int = response[1]
	var raw: PackedByteArray = response[3]

	if result != HTTPRequest.RESULT_SUCCESS:
		return _fail(0, "Không kết nối được máy chủ. Kiểm tra mạng và thử lại.")

	var parsed: Variant = null
	if raw.size() > 0:
		parsed = JSON.parse_string(raw.get_string_from_utf8())

	if status >= 200 and status < 300:
		return { "ok": true, "status": status, "data": parsed, "error": "" }

	# Token expired or revoked: end the session (Router sends the user to login).
	if status == 401 and Session.is_logged_in():
		Session.logout()

	return _fail(status, _error_message(parsed, status))


func _fail(status: int, message: String) -> Dictionary:
	return { "ok": false, "status": status, "data": null, "error": message }


## Reads ASP.NET ProblemDetails / ValidationProblemDetails.
func _error_message(problem: Variant, status: int) -> String:
	if problem is Dictionary:
		var errors: Variant = problem.get("errors")
		if errors is Dictionary and not errors.is_empty():
			var messages: PackedStringArray = []
			for field in errors:
				for message in errors[field]:
					messages.append(str(message))
			return "\n".join(messages)
		if problem.get("detail"):
			return str(problem["detail"])
		if problem.get("title"):
			return str(problem["title"])
	return "Lỗi máy chủ (%d)." % status
