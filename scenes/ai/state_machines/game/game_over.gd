extends GameState


const SFX_ACTIVITY_START = preload("uid://dny2e60a14bx6")


func enter(subject: Game) -> void:
	subject.get_ui().show_press_any_button_indicator()


func exit(subject: Game) -> void:
	subject.get_ui().hide_press_any_button_indicator()


func input(subject, event: InputEvent) -> void:
	if event.is_action_pressed("clean") or \
			event.is_action_pressed("feed") or \
			event.is_action_pressed("repair"):
				_play_again(subject)


func _play_again(subject: Game) -> void:
	SoundManager.play_sound(SFX_ACTIVITY_START)
	subject.get_ui().hide_press_any_button_indicator()
	subject.get_state_machine().change_state("NotStarted")
