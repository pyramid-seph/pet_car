extends Node

enum State {
	TITLE_SCREEN,
	STARTED,
	GAME_OVER,
}

var _state: State

@onready var _pet := %Pet
@onready var _ui := %Ui


func _ready() -> void:
	if OS.is_debug_build():
		get_window().always_on_top = true
	
	_on_pet_wear_changed()
	_on_pet_hunger_changed()
	_on_pet_dirty_changed()
	
	_ui.hide_turn_off_instructions()


func _start_game() -> void:
	print("Game started.")
	print("==================================\n")
	_pet.be_born()
	_ui.hide_press_any_button_indicator()
	_state = State.STARTED


func _game_over() -> void:
	print("Game over.")
	_ui.show_press_any_button_indicator()
	_state = State.GAME_OVER


func _on_repair_progress_bar_button_pressed() -> void:
	match _state:
		State.TITLE_SCREEN:
			_start_game()
		State.STARTED:
			_pet.repair()
		State.GAME_OVER:
			_pet.revive()


func _on_feed_progress_bar_button_pressed() -> void:
	match _state:
		State.TITLE_SCREEN:
			_start_game()
		State.STARTED:
			_pet.feed()
		State.GAME_OVER:
			_pet.revive()


func _on_clean_progress_bar_button_pressed() -> void:
	match _state:
		State.TITLE_SCREEN:
			_start_game()
		State.STARTED:
			_pet.clean()
		State.GAME_OVER:
			_pet.revive()


func _on_pet_died() -> void:
	_game_over()


func _on_pet_wear_changed() -> void:
	if not is_node_ready():
		return
	
	if _state == State.STARTED:
		_ui.update_wear(_pet.get_wear())
	else:
		_ui.update_wear_no_anim(_pet.get_wear())


func _on_pet_hunger_changed() -> void:
	if not is_node_ready():
		return
	
	if _state == State.STARTED:
		_ui.update_hunger(_pet.get_hunger())
	else:
		_ui.update_hunger_no_anim(_pet.get_hunger())


func _on_pet_dirty_changed() -> void:
	if not is_node_ready():
		return
	
	if _state == State.STARTED:
		_ui.update_dirt(_pet.get_dirt())
	else:
		_ui.update_dirt_no_anim(_pet.get_dirt())


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
