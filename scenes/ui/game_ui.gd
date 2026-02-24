class_name GameUi
extends Control


@onready var _press_any_button_label: Label = %PressAnyButtonLabel
@onready var _turn_off_instructions: Label = %TurnOffIntructions
@onready var _clock: Label = %Clock
@onready var _bars_container: HBoxContainer = %BarsContainer
@onready var _wear_bar := %WearBar
@onready var _hunger_bar := %HungerBar
@onready var _dirt_bar := %DirtBar
@onready var _mileage_label: Label = %MileageLabel
@onready var _mileage_container: VBoxContainer = %MileageContainer


func _ready() -> void:
	hide_turn_off_instructions()


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


func show_turn_off_instructions() -> void:
	_turn_off_instructions.show()
	_clock.hide()


func hide_turn_off_instructions() -> void:
	_turn_off_instructions.hide()
	_clock.show()


func update_mileage(value: int) -> void:
	_mileage_label.text = str(value)


func show_time_passed() -> void:
	_mileage_container.show()


func hide_time_passed() -> void:
	_mileage_container.hide()
