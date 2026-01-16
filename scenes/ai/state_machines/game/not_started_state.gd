extends GameState


const PET_HIDDEN_DURATION_SEC: float = 1.0
const START_GAME_ALLOWED_DELAY_SEC: float = PET_HIDDEN_DURATION_SEC + 1.0


var _pet_hidden_timer: Timer
var _start_game_delay_timer: Timer


func _init() -> void:
	_start_game_delay_timer = Timer.new()
	_start_game_delay_timer.one_shot = true
	add_child(_start_game_delay_timer)
	
	_pet_hidden_timer = Timer.new()
	_pet_hidden_timer.one_shot = true
	add_child(_pet_hidden_timer)


func enter(subject: Game) -> void:
	subject.get_ui().hide_press_any_button_indicator()
	subject.get_pet().revive()
	subject.get_pet().hide()
	
	_start_game_delay_timer.timeout.connect(
		_on_start_game_delay_timer_timeout.bind(subject), CONNECT_ONE_SHOT)
	_pet_hidden_timer.timeout.connect(
		_on_pet_hidden_timer_timeout.bind(subject), CONNECT_ONE_SHOT)
	
	_pet_hidden_timer.start(PET_HIDDEN_DURATION_SEC)
	_start_game_delay_timer.start(START_GAME_ALLOWED_DELAY_SEC)


func exit(subject: Game) -> void:
	Utils.safe_disconnect(_start_game_delay_timer.timeout,
			_on_start_game_delay_timer_timeout)
	Utils.safe_disconnect(_pet_hidden_timer.timeout,
			_on_pet_hidden_timer_timeout)
	
	_pet_hidden_timer.stop()
	_start_game_delay_timer.stop()
	
	subject.get_pet().show()
	subject.get_ui().hide_press_any_button_indicator()


func _start_game(subject: Game) -> void:
	if _start_game_delay_timer.is_stopped():
		subject.get_ui().hide_press_any_button_indicator()
		subject.get_state_machine().change_state("Started")


func on_repair_progress_bar_button_pressed(subject: Game) -> void:
	_start_game(subject)


func on_feed_progress_bar_button_pressed(subject: Game) -> void:
	_start_game(subject)


func on_clean_progress_bar_button_pressed(subject: Game) -> void:
	_start_game(subject)


func on_pet_wear_changed(subject: Game) -> void:
	subject.get_ui().update_wear_no_anim(subject.get_pet().get_wear())


func on_pet_hunger_changed(subject: Game) -> void:
	subject.get_ui().update_hunger_no_anim(subject.get_pet().get_hunger())


func on_pet_dirty_changed(subject: Game) -> void:
	subject.get_ui().update_dirt_no_anim(subject.get_pet().get_dirt())


func _on_start_game_delay_timer_timeout(subject: Game) -> void:
	subject.get_ui().show_press_any_button_indicator()


func _on_pet_hidden_timer_timeout(subject: Game) -> void:
	subject.get_pet().show()
