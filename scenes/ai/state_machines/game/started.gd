extends GameState


func enter(subject: Game) -> void:
	subject.get_ui().hide_state_bars()
	subject.get_pet().be_born()


func input(subject: Game, event: InputEvent) -> void:
	if event.is_action_pressed("clean"):
		subject.get_pet().clean()
	if event.is_action_pressed("feed"):
		subject.get_pet().feed()
	if event.is_action_pressed("repair"):
		subject.get_pet().repair()


func on_pet_died(subject: Game) -> void:
	subject.get_state_machine().change_state("GameOver")


func on_pet_borned(subject: Game) -> void:
	subject.get_ui().show_state_bars()
