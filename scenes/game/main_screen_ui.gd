extends Control


signal settings_panel_opened(available_space: Rect2)

@onready var _settings_panel: PanelContainer = %SettingsPanel
@onready var _empty_space: Control = %EmptySpace



func _on_open_settings_button_toggled(toggled_on: bool) -> void:
	_settings_panel.visible = toggled_on


func _on_empty_space_item_rect_changed() -> void:
	settings_panel_opened.emit(_empty_space.get_rect())
