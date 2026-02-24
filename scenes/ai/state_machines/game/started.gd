extends GameState

const MAX_MILEAGE: int = 999
const MILEAGE_UPDATE_SEC: int = 60

var _mileage: int
var _mileage_timer: Timer


func _init() -> void:
	_mileage_timer = Timer.new()
	_mileage_timer.autostart = false
	_mileage_timer.wait_time = MILEAGE_UPDATE_SEC
	add_child(_mileage_timer)


func enter(subject: Game) -> void:
	subject.get_ui().hide_state_bars()
	
	var pet: Pet = subject.get_pet()
	pet.be_born()
	
	_mileage = 0
	subject.get_ui().update_mileage(_mileage)
	
	Utils.safe_connect(pet.busy, _on_pet_busy.bind(subject))
	Utils.safe_connect(pet.idle, _on_pet_idle.bind(subject))
	Utils.safe_connect(pet.died, _on_pet_died.bind(subject))
	Utils.safe_connect(pet.borned, _on_pet_borned.bind(subject))
	Utils.safe_connect(pet.dying, _on_pet_dying)
	Utils.safe_connect(_mileage_timer.timeout, 
			_on_mileage_timer_timeout.bind(subject))


func exit(subject: Game) -> void:
	var pet: Pet = subject.get_pet()
	Utils.safe_disconnect(pet.busy, _on_pet_busy.bind(subject))
	Utils.safe_disconnect(pet.idle, _on_pet_idle.bind(subject))
	Utils.safe_disconnect(pet.died, _on_pet_died.bind(subject))
	Utils.safe_disconnect(pet.borned, _on_pet_borned.bind(subject))
	Utils.safe_disconnect(pet.dying, _on_pet_dying)
	Utils.safe_disconnect(_mileage_timer.timeout,
			_on_mileage_timer_timeout.bind(subject))
	
	_mileage_timer.stop()


func input(subject: Game, event: InputEvent) -> void:
	if event.is_action_pressed("clean"):
		subject.get_pet().clean()
	if event.is_action_pressed("feed"):
		subject.get_pet().feed()
	if event.is_action_pressed("repair"):
		subject.get_pet().repair()


func _on_pet_busy(subject: Game) -> void:
	subject.get_ui().hide_time_passed()
	_mileage_timer.paused = true


func _on_pet_idle(subject: Game) -> void:
	subject.get_ui().show_time_passed()
	_mileage_timer.paused = false


func _on_mileage_timer_timeout(subject: Game) -> void:
	_mileage = clampi(_mileage + 1, 0, MAX_MILEAGE)
	subject.get_ui().update_mileage(_mileage)


func _on_pet_dying() -> void:
	_mileage_timer.stop()


func _on_pet_died(subject: Game) -> void:
	subject.get_state_machine().change_state("GameOver")


func _on_pet_borned(subject: Game) -> void:
	subject.get_ui().show_state_bars()
	subject.get_ui().show_time_passed()
	_mileage_timer.start()
