extends PetState


var _is_being_taken_care_of: bool


func enter(subject: Pet) -> void:
	Log.d("Pet started their live.")
	subject.reset_tick_duration()
	subject.pause_ticks(false)
	subject.start_a_tick()
	_update_state_anim(subject)


func repair(subject: Pet) -> void:
	if _is_being_taken_care_of or not subject.is_worn_out():
		return
	_is_being_taken_care_of = true
	
	Log.d("Pet is being repaired.")
	subject.pause_ticks(true)
	subject.reduce_wear()
	subject.get_animation_player().play(&"repair")


func feed(subject: Pet) -> void:
	if _is_being_taken_care_of or not subject.is_hungry():
		return
	_is_being_taken_care_of = true
	
	Log.d("Pet is being fed.")
	subject.pause_ticks(true)
	subject.reduce_hunger()
	subject.get_animation_player().play(&"feed")


func clean(subject: Pet) -> void:
	if _is_being_taken_care_of or not subject.is_dirty():
		return
	_is_being_taken_care_of = true
	
	Log.d("Pet is being cleaned.")
	subject.pause_ticks(true)
	subject.reduce_dirt()
	subject.get_animation_player().play(&"clean")


func on_tick(subject: Pet) -> void:
	subject.increase_discomforts()
	if subject.any_discomfort_exceeded():
		subject.get_state_machine().change_state("Dead")
	else:
		subject.decrease_tick_duration()
		subject.start_a_tick()
		_update_state_anim(subject)


func on_animation_finished(subject: Pet, anim_name: StringName) -> void:
	match anim_name:
		&"repair", &"clean", &"feed":
			_is_being_taken_care_of = false
			subject.pause_ticks(false)
			_update_state_anim(subject)


func _update_state_anim(subject: Pet) -> void:
	if subject.any_discomfort_exceeded():
		return
	
	var new_anim: StringName = &"idle"
	if subject.is_worn_out():
		new_anim = &"worn_out"
	elif subject.is_hungry():
		new_anim = &"hungry"
	elif subject.is_dirty():
		new_anim = &"dirty"
	subject.get_animation_player().play(new_anim)
