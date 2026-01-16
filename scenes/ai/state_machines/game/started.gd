extends GameState


func enter(subject: Game) -> void:
	subject.get_pet().be_born()


func on_repair_progress_bar_button_pressed(subject: Game) -> void:
	subject.get_pet().repair()


func on_feed_progress_bar_button_pressed(subject: Game) -> void:
	subject.get_pet().feed()


func on_clean_progress_bar_button_pressed(subject: Game) -> void:
	subject.get_pet().clean()


func on_pet_died(subject: Game) -> void:
	subject.get_state_machine().change_state("GameOver")


func on_pet_wear_changed(subject: Game) -> void:
	subject.get_ui().update_wear(subject.get_pet().get_wear())


func on_pet_hunger_changed(subject: Game) -> void:
	subject.get_ui().update_hunger(subject.get_pet().get_hunger())


func on_pet_dirty_changed(subject: Game) -> void:
	subject.get_ui().update_dirt(subject.get_pet().get_dirt())
