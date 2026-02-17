class_name Game
extends Node


var _turn_off_long_press := LongPressAction.new(&"turn_off", 1.5, 
		LongPressAction.CheckMode.ON_PRESS)

@onready var _pet: Pet = %Pet
@onready var _state_machine: GameStateMachine = %GameStateMachine
@onready var _ui: GameUi = %Ui


func _ready() -> void:
	_turn_off_long_press.started.connect(_on_turn_off_long_press_started)
	_turn_off_long_press.canceled.connect(_on_turn_off_long_press_canceled)
	_turn_off_long_press.completed.connect(_on_turn_off_long_press_completed)
	
	_on_viewport_size_changed()
	get_viewport().size_changed.connect(_on_viewport_size_changed)


func _process(delta: float) -> void:
	_turn_off_long_press.update(delta)


func get_state_machine() -> GameStateMachine:
	return _state_machine


func get_ui() -> GameUi: 
	return _ui


func get_pet() -> Pet:
	return _pet


func _on_viewport_size_changed() -> void:
	var center_pos: Vector2 = get_viewport().get_visible_rect().size / 2.0
	_pet.position = center_pos


func _on_turn_off_long_press_started() -> void:
	_ui.show_turn_off_instructions()


func _on_turn_off_long_press_canceled() -> void:
	_ui.hide_turn_off_instructions()


func _on_turn_off_long_press_completed() -> void:
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


func _on_pet_dirty_changed() -> void:
	if is_node_ready():
		_ui.update_dirt(_pet.get_dirt(), _pet.is_dirty())


func _on_pet_hunger_changed() -> void:
	if is_node_ready():
		_ui.update_hunger(_pet.get_hunger(), _pet.is_hungry())


func _on_pet_wear_changed() -> void:
	if is_node_ready():
		_ui.update_wear(_pet.get_wear(), _pet.is_worn_out())


func _on_pet_died() -> void:
	_state_machine.on_pet_died()


func _on_pet_borned() -> void:
	_state_machine.on_pet_borned()
