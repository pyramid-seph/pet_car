extends Node


func _init() -> void:
	if OS.is_debug_build():
		var screenshot_tool := ScreenshotTool.new()
		add_child(screenshot_tool)


func _ready() -> void:
	get_window().always_on_top = true
	Settings.language_changed.connect(_on_settings_language_changed)


func _on_settings_language_changed() -> void:
	TranslationServer.set_locale(Settings.get_language())
