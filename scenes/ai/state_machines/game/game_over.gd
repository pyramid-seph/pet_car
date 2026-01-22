extends GameState


func enter(subject: Game) -> void:
	subject.get_ui().show_press_any_button_indicator()


func exit(subject: Game) -> void:
	subject.get_ui().hide_press_any_button_indicator()


func play_again(subject: Game) -> void:
	subject.get_ui().hide_press_any_button_indicator()
	subject.get_state_machine().change_state("NotStarted")


func on_repair_button_pressed(subject: Game) -> void:
	play_again(subject)


func on_feed_button_pressed(subject: Game) -> void:
	play_again(subject)


func on_clean_button_pressed(subject: Game) -> void:
	play_again(subject)


func on_pet_wear_changed(subject: Game) -> void:
	subject.get_ui().update_wear_no_anim(subject.get_pet().get_wear())


func on_pet_hunger_changed(subject: Game) -> void:
	subject.get_ui().update_hunger_no_anim(subject.get_pet().get_hunger())


func on_pet_dirty_changed(subject: Game) -> void:
	subject.get_ui().update_dirt_no_anim(subject.get_pet().get_dirt())
