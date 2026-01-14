class_name PetStateMachine
extends BaseStateMachine


func be_born() -> void:
	var state := get_current_state() as PetState
	var subject := get_subject() as Pet 
	if state and subject:
		state.be_born(subject)


func on_tick() -> void:
	var state := get_current_state() as PetState
	var subject := get_subject() as Pet 
	if state and subject:
		state.on_tick(subject)


func feed() -> void:
	var state := get_current_state() as PetState
	var subject := get_subject() as Pet 
	if state and subject:
		state.feed(subject)


func repair() -> void:
	var state := get_current_state() as PetState
	var subject := get_subject() as Pet 
	if state and subject:
		state.repair(subject)


func clean() -> void:
	var state := get_current_state() as PetState
	var subject := get_subject() as Pet 
	if state and subject:
		state.clean(subject)


func on_animation_finished(anim_name: StringName) -> void:
	var state := get_current_state() as PetState
	var subject := get_subject() as Pet 
	if state and subject:
		state.on_animation_finished(subject, anim_name)
