extends Control


@onready var _settings_panel: PanelContainer = %SettingsPanel
@onready var _handle_button: TextureButton = %HandleButton
@onready var _press_any_button_label: Label = %PressAnyButtonLabel
@onready var _turn_off_instructions: Label = %TurnOffIntructions
@onready var _clock: Label = %Clock
@onready var _bars_container: HBoxContainer = %BarsContainer
@onready var _wear_bar := %WearBar
@onready var _hunger_bar := %HungerBar
@onready var _dirt_bar := %DirtBar


func _ready() -> void:
	_hide_turn_off_instructions()
	if Utils.can_run_js():
		_handle_button.hide()


func open_settings() -> void:
	_settings_panel.show()


func close_settings() -> void:
	_settings_panel.hide()


func update_wear(value: int, warn: bool) -> void:
	_wear_bar.value = 100 - value
	_wear_bar.warn = warn


func update_hunger(value: int, warn: bool) -> void:
	_hunger_bar.value = 100 - value
	_hunger_bar.warn = warn


func update_dirt(value: int, warn: bool) -> void:
	_dirt_bar.value = 100 - value
	_dirt_bar.warn = warn


func show_state_bars() -> void:
	_bars_container.modulate.a = 1.0


func hide_state_bars() -> void:
	_bars_container.modulate.a = 0.0


func show_press_any_button_indicator() -> void:
	_press_any_button_label.show()


func hide_press_any_button_indicator() -> void:
	_press_any_button_label.hide()


func _show_turn_off_instructions() -> void:
	_turn_off_instructions.show()
	_clock.hide()


func _hide_turn_off_instructions() -> void:
	_turn_off_instructions.hide()
	_clock.show()


func _on_power_off_button_button_up() -> void:
	_hide_turn_off_instructions()


func _on_power_off_button_button_down() -> void:
	_show_turn_off_instructions()


func _on_open_settings_button_toggled(toggled_on: bool) -> void:
	_settings_panel.visible = toggled_on


func _on_handle_button_button_down() -> void:
	get_window().start_drag()
