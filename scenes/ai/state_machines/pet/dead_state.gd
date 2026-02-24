extends PetState


func enter(subject: Pet) -> void:
	Log.d("Pet dead.")
	subject.stop_ticks()
	subject.update_body_parts()
	subject.dying.emit()
	subject.get_animation_player().play(&"die")


func on_animation_finished(subject: Pet, anim_name: StringName) -> void:
	if anim_name == &"die":
		subject.died.emit()
