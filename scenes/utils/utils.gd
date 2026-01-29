class_name Utils
extends RefCounted


const SUPPORTED_LANGUAGES: Array[Dictionary] = [
	{
		"name": "English",
		"code": "en"
	},
	{
		"name": "Español",
		"code": "es"
	}
]

static func safe_connect(signal_object: Signal, callable: Callable,
		flags: int = 0) -> void:
	if not signal_object.is_connected(callable):
		signal_object.connect(callable, flags)


static func safe_disconnect(signal_object: Signal, callable: Callable) -> void:
	if signal_object.is_connected(callable):
		signal_object.disconnect(callable)


static func can_run_js() -> bool:
	return OS.has_feature("web")


static func is_supported_language(lang_code: String) -> bool:
	return Utils.SUPPORTED_LANGUAGES.find_custom(
			func(lang: Dictionary): return lang.code == lang_code) > -1


static func supported_lang_or_default(lang_code: String) -> String:
	if is_supported_language(lang_code):
		return lang_code
	else:
		return SUPPORTED_LANGUAGES[0].code
	


static func get_game_version() -> String:
	return "v %s" % ProjectSettings.get_setting("application/config/version")
