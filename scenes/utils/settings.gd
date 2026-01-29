extends Node


signal saved
signal language_changed
signal body_color_changed
signal pattern_color_changed
signal pattern_offset_changed

const _SETTINGS_FILE_PATH: String = "user://settings.cfg"
const _SECTION = "settings"
const _KEY_LANGUAGE: String = "language"
const _KEY_BODY_COLOR: String = "body_color"
const _KEY_PATTERN_COLOR: String = "pattern_color"
const _KEY_PATTERN_OFFSET: String = "pattern_offset"

var config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	_load_settings()


func get_language() -> String:
	return config.get_value(_SECTION, _KEY_LANGUAGE)


func set_language(value: String) -> void:
	var old_val: String = get_language()
	var new_val: String = Utils.supported_lang_or_default(value)
	if old_val != new_val:
		config.set_value(_SECTION, _KEY_LANGUAGE, new_val)
		language_changed.emit()


func get_body_color() -> Color:
	return config.get_value(_SECTION, _KEY_BODY_COLOR)


func set_body_color(value: Color) -> void:
	var old_val: Color = get_body_color()
	if old_val != value:
		config.set_value(_SECTION, _KEY_BODY_COLOR, value)
		body_color_changed.emit()


func get_pattern_color() -> Color:
	return config.get_value(_SECTION, _KEY_PATTERN_COLOR)


func set_pattern_color(value: Color) -> void:
	var old_val: Color = get_pattern_color()
	if old_val != value:
		config.set_value(_SECTION, _KEY_PATTERN_COLOR, value)
		pattern_color_changed.emit()


func get_pattern_offset() -> Vector2:
	return config.get_value(_SECTION, _KEY_PATTERN_OFFSET)


func set_pattern_offset(x: float, y: float) -> void:
	var old_val: Vector2 = get_pattern_offset()
	var new_val := Vector2(x, y)
	if old_val != new_val:
		config.set_value(_SECTION, _KEY_PATTERN_OFFSET, new_val)
		pattern_offset_changed.emit()


func save() -> void:
	var error: int = config.save(_SETTINGS_FILE_PATH)
	if error:
		Log.d("Error while saving settings.")
	else:
		Log.d("Settings saved.")
		saved.emit()


func _load_settings() -> void:
	var error: int = config.load(_SETTINGS_FILE_PATH)
	if error:
		Log.w("Settings file not found. Creting a new one.")
		_create_settings_file()


func _create_settings_file() -> void:
	config.set_value(_SECTION, _KEY_LANGUAGE,
			Utils.supported_lang_or_default(OS.get_locale_language()))
	config.set_value(_SECTION, _KEY_BODY_COLOR, _pick_random_color())
	config.set_value(_SECTION, _KEY_PATTERN_COLOR, _pick_random_color())
	config.set_value(_SECTION, _KEY_PATTERN_OFFSET, _pick_random_offset())
	set_block_signals(true)
	save()
	set_block_signals(false)


func _pick_random_color() -> Color:
	return Color(randf(), randf(), randf())


func _pick_random_offset() -> Vector2:
	return Vector2(randf(), randf())
