extends PetState


var _is_being_taken_care_of: bool


func enter(subject: Pet) -> void:
	Log.d("Pet started their live.")
	subject.reset_tick_duration()
	subject.pause_ticks(false)
	subject.start_a_tick()
	subject.update_body_parts()
	subject.get_animation_player().play(&"idle")
	subject.borned.emit()


func repair(subject: Pet) -> void:
	if _is_being_taken_care_of or not subject.is_worn_out():
		return
	_is_being_taken_care_of = true
	
	Log.d("Pet is being repaired.")
	subject.pause_ticks(true)
	subject.get_animation_player().play(&"repair")


func feed(subject: Pet) -> void:
	if _is_being_taken_care_of or not subject.is_hungry():
		return
	_is_being_taken_care_of = true
	
	Log.d("Pet is being fed.")
	subject.pause_ticks(true)
	subject.get_animation_player().play(&"feed")


func clean(subject: Pet) -> void:
	if _is_being_taken_care_of or not subject.is_dirty():
		return
	_is_being_taken_care_of = true
	
	Log.d("Pet is being cleaned.")
	subject.pause_ticks(true)
	subject.get_animation_player().play(&"clean")


func on_tick(subject: Pet) -> void:
	subject.increase_discomforts()
	if subject.any_discomfort_exceeded():
		subject.get_state_machine().change_state("Dead")
	else:
		subject.decrease_tick_duration()
		subject.start_a_tick()
		subject.update_body_parts()


func on_animation_finished(subject: Pet, anim_name: StringName) -> void:
	if anim_name not in [&"repair", &"clean", &"feed"]:
		return
	
	match anim_name:
		&"repair":
			subject.reduce_wear()
		&"clean":
			subject.reduce_dirt()
		&"feed":
			subject.reduce_hunger()
		
	_is_being_taken_care_of = false
	subject.pause_ticks(false)
	subject.update_body_parts()
	subject.get_animation_player().play(&"idle")
