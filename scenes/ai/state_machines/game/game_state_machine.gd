class_name GameStateMachine
extends BaseStateMachine


func on_repair_progress_bar_button_pressed() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_repair_progress_bar_button_pressed(subject)


func on_feed_progress_bar_button_pressed() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_feed_progress_bar_button_pressed(subject)


func on_clean_progress_bar_button_pressed() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_clean_progress_bar_button_pressed(subject)


func on_pet_died() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_pet_died(subject)


func on_pet_wear_changed() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_pet_wear_changed(subject)


func on_pet_hunger_changed() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_pet_hunger_changed(subject)


func on_pet_dirty_changed() -> void:
	var state := get_current_state() as GameState
	var subject := get_subject() as Game 
	if state and subject:
		state.on_pet_dirty_changed(subject)
