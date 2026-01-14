extends Node

enum State {
	TITLE_SCREEN,
	STARTED,
	GAME_OVER,
}

var _state: State

@onready var _pet := %Pet
@onready var _repair_progress_bar_button := %RepairProgressBarButton
@onready var _feed_progress_bar_button := %FeedProgressBarButton
@onready var _clean_progress_bar_button := %CleanProgressBarButton
@onready var _press_any_button_container: VBoxContainer = %PressAnyButtonContainer
@onready var _turn_off_instructions_container := %TurnOffInstructionsContainer


func _ready() -> void:
	if OS.is_debug_build():
		get_window().always_on_top = true
	
	_on_pet_wear_changed()
	_on_pet_hunger_changed()
	_on_pet_dirty_changed()
	
	_turn_off_instructions_container.hide()


func _start_game() -> void:
	print("Game started.")
	print("==================================\n")
	_pet.be_born()
	_press_any_button_container.hide()
	_state = State.STARTED


func _game_over() -> void:
	print("Game over.")
	_press_any_button_container.show()
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
	
	var new_val: int = 100 - _pet.get_wear()
	if new_val > 0 and new_val < 5:
		new_val = 5
	if _state == State.STARTED:
		_repair_progress_bar_button.progress = new_val
	else:
		_repair_progress_bar_button.set_progress_no_anim(new_val)


func _on_pet_hunger_changed() -> void:
	if not is_node_ready():
		return
	
	var new_val: int = 100 - _pet.get_hunger()
	if new_val > 0 and new_val < 5:
		new_val = 5
	if _state == State.STARTED:
		_feed_progress_bar_button.progress = new_val
	else:
		_feed_progress_bar_button.set_progress_no_anim(new_val)


func _on_pet_dirty_changed() -> void:
	if not is_node_ready():
		return
	
	var new_val: int = 100 - _pet.get_dirt()
	if new_val > 0 and new_val < 5:
		new_val = 5
	if _state == State.STARTED:
		_clean_progress_bar_button.progress = new_val
	else:
		_clean_progress_bar_button.set_progress_no_anim(new_val)


func _on_handle_button_button_down() -> void:
	get_window().start_drag()


func _on_power_off_button_long_pressed() -> void:
	print("\n*****\n")
	print("Game quit.")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_power_off_button_button_up() -> void:
	_turn_off_instructions_container.hide()


func _on_power_off_button_button_down() -> void:
	_turn_off_instructions_container.show()
