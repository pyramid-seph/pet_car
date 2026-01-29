class_name Game
extends Node


@onready var _pet := %Pet
@onready var _ui := %Ui
@onready var _state_machine: GameStateMachine = $GameStateMachine


func _ready() -> void:
	_on_pet_wear_changed()
	_on_pet_hunger_changed()
	_on_pet_dirty_changed()


func get_ui():
	return _ui


func get_pet() -> Pet:
	return _pet


func get_state_machine() -> GameStateMachine:
	return _state_machine


func _on_pet_borned() -> void:
	_state_machine.on_pet_borned()


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


func _on_power_off_button_long_pressed() -> void:
	Log.d("\n*****\n")
	Log.d("Quitting game...")
	
	if Utils.can_run_js():
		# TODO Save settings before closing. Eval seems to prevent
		# other calls inside this function to be called,
		# even if they are placed before it.
		JavaScriptBridge.eval("window.close();")
	else:
		Settings.save()
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()


func _on_repair_button_pressed() -> void:
	_state_machine.on_repair_button_pressed()


func _on_feed_button_pressed() -> void:
	_state_machine.on_feed_button_pressed()


func _on_clean_button_pressed() -> void:
	_state_machine.on_clean_button_pressed()
