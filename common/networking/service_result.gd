class_name ServiceResult
extends RefCounted
## Shared result shape for services: { ok: bool, status: int, data: Variant, error: String }
## (same as Api), so screens handle mock and real data the same way.


static func ok(data: Variant) -> Dictionary:
	return { "ok": true, "status": 200, "data": data, "error": "" }


static func fail(message: String, status: int = 0) -> Dictionary:
	return { "ok": false, "status": status, "data": null, "error": message }


## Mock services await this so they are async like real API calls (callers always `await`).
static func mock_delay() -> void:
	await (Engine.get_main_loop() as SceneTree).process_frame
