extends PetState


func enter(subject: Pet) -> void:
	Log.d("Pet conceived.")
	subject.stop_ticks()
	subject.reset_discomforts()
	subject.get_animation_player().play(&"conceived")


func be_born(subject: Pet) -> void:
	subject.get_animation_player().play(&"born")


func on_animation_finished(subject: Pet, anim_name: StringName) -> void:
	if anim_name == &"born":
		Log.d("Pet born.")
		subject.get_state_machine().change_state("Alive")
