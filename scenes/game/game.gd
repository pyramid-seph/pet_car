class_name Game
extends Node


@onready var _pet := %Pet
@onready var _ui := %Ui
@onready var _state_machine: GameStateMachine = $GameStateMachine


func _ready() -> void:
	if OS.is_debug_build():
		get_window().always_on_top = true
	
	_on_pet_wear_changed()
	_on_pet_hunger_changed()
	_on_pet_dirty_changed()
	
	_ui.hide_turn_off_instructions()


func get_ui():
	return _ui


func get_pet() -> Pet:
	return _pet


func get_state_machine() -> GameStateMachine:
	return _state_machine


func _on_repair_progress_bar_button_pressed() -> void:
	_state_machine.on_repair_progress_bar_button_pressed()


func _on_feed_progress_bar_button_pressed() -> void:
	_state_machine.on_feed_progress_bar_button_pressed()


func _on_clean_progress_bar_button_pressed() -> void:
	_state_machine.on_clean_progress_bar_button_pressed()


func _on_pet_died() -> void:
	_state_machine.on_pet_died()


func _on_pet_wear_changed() -> void:
	if is_node_ready():
		_state_machine.on_pet_wear_changed()


func _on_pet_hunger_changed() -> void:
	if is_node_ready():
		_state_machine.on_pet_hunger_changed()


func _on_pet_dirty_changed() -> void:
	if is_node_ready():
		_state_machine.on_pet_dirty_changed()


func _on_handle_button_button_down() -> void:
	get_window().start_drag()


func _on_power_off_button_long_pressed() -> void:
	print("\n*****\n")
	print("Game quit.")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_power_off_button_button_up() -> void:
	_ui.hide_turn_off_instructions()


func _on_power_off_button_button_down() -> void:
	_ui.show_turn_off_instructions()
