extends PetState


func enter(subject: Pet) -> void:
	subject.get_animation_player().play("idle")
