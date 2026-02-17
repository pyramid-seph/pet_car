extends Control


@onready var _settings_panel: PanelContainer = %SettingsPanel


func _on_open_settings_button_toggled(toggled_on: bool) -> void:
	_settings_panel.visible = toggled_on
