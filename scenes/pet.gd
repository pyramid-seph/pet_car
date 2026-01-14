class_name Pet
extends Sprite2D


@warning_ignore("unused_signal")
signal died
signal hunger_changed
signal dirty_changed
signal wear_changed


enum Discomforts {
	DIRT = 1,
	HUNGER = 2,
	WEAR = 4,
}

const MAX_STATUS_VALUE: int = 100
const WARN_VALUE: int = 75
const MIN_STATUS_VALUE: int = 0

@export_range(1, 60, 1, "or_greater") var _min_tick_sec: int = 1
@export_range(1, 60, 1, "or_greater") var _max_tick_sec: int = 1
@export_range(0.1, 1.0, 0.05, "or_greater")
var _max_duration_lost_per_tick_sec: float = 0.5
@export_group("Damage")
@export_range(1, 100) var _min_hunger_damage: int = 1
@export_range(1, 100) var _max_hunger_damage: int = 1
@export_range(1, 100) var _min_wear_damage: int = 1
@export_range(1, 100) var _max_wear_damage: int = 1
@export_range(1, 100) var _min_dirt_damage: int = 1
@export_range(1, 100) var _max_dirt_damage: int = 1
@export_group("Reduction")
@export_range(1, 100) var _min_hunger_reduction: int = 1
@export_range(1, 100) var _max_hunger_reduction: int = 1
@export_range(1, 100) var _min_wear_reduction: int = 1
@export_range(1, 100) var _max_wear_reduction: int = 1
@export_range(1, 100) var _min_dirt_reduction: int = 1
@export_range(1, 100) var _max_dirt_reduction: int = 1

var _curr_max_tick_duration: float
var _hunger: int:
	set(value):
		_hunger = clampi(value, MIN_STATUS_VALUE, MAX_STATUS_VALUE)
		hunger_changed.emit()
var _wear: int:
	set(value):
		_wear = clampi(value, MIN_STATUS_VALUE, MAX_STATUS_VALUE)
		wear_changed.emit()
var _dirt: int:
	set(value):
		_dirt = clampi(value, MIN_STATUS_VALUE, MAX_STATUS_VALUE)
		dirty_changed.emit()

@onready var _tick_timer: Timer = $TickTimer
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _state_machine: PetStateMachine = $PetStateMachine


func revive() -> void:
	_state_machine.start()


func be_born() -> void:
	_state_machine.be_born()


func feed() -> void:
	_state_machine.feed()


func repair() -> void:
	_state_machine.repair()


func clean() -> void:
	_state_machine.clean()


func get_hunger() -> int:
	return _hunger


func get_wear() -> int:
	return _wear


func get_dirt() -> int:
	return _dirt


func is_worn_out() -> bool:
	return _wear > WARN_VALUE


func is_hungry() -> bool:
	return _hunger > WARN_VALUE


func is_dirty() -> bool:
	return _dirt > WARN_VALUE


func any_discomfort_exceeded() -> bool:
	return _hunger >= MAX_STATUS_VALUE or _wear >= MAX_STATUS_VALUE or \
			_dirt >= MAX_STATUS_VALUE 


#region Used only by state machine's states

func get_animation_player() -> AnimationPlayer:
	return _animation_player


func get_state_machine() -> PetStateMachine:
	return _state_machine


func reduce_hunger() -> void:
	var reduction: int = randi_range(_min_hunger_reduction, _max_hunger_reduction)
	_hunger -= reduction
	print("Fed. Reduction: ", reduction, " - Current val: ", _hunger)


func reduce_wear() -> void:
	var reduction: int = randi_range(_min_wear_reduction, _max_wear_reduction)
	_wear -= reduction


func reduce_dirt() -> void:
	var reduction: int = randi_range(_min_dirt_reduction, _max_dirt_reduction)
	_dirt -= reduction


func increase_discomforts() -> void:
	if any_discomfort_exceeded():
		return
	
	var increased_discomforts: int = randi_range(0, 7)
	if increased_discomforts == 0:
		print("Discomforts were NOT increased. Lucky!")
		return

	if increased_discomforts & Discomforts.DIRT:
		var increase: int = randi_range(_min_dirt_damage, _max_dirt_damage)
		_dirt += increase
		print("Dirt increased to %s (+%s)" % [_dirt, increase])
	
	if increased_discomforts & Discomforts.HUNGER:
		var increase: int = randi_range(_min_hunger_damage, _max_hunger_damage)
		_hunger += increase
		print("Hunger increased to %s (+%s)" % [_hunger, increase])
	
	if increased_discomforts & Discomforts.WEAR:
		var increase: int = randi_range(_min_wear_damage, _max_wear_damage)
		_wear += increase
		print("Wear increased to %s (+%s)" % [_wear, increase])


func reset_discomforts() -> void:
	_hunger = 0
	_wear = 0
	_dirt = 0
	print("Discomforts were reset.")


func decrease_tick_duration() -> void:
	var tick_duration_lose: float = \
			randf_range(0.0, _max_duration_lost_per_tick_sec)
	_curr_max_tick_duration = clampf(
			_curr_max_tick_duration - tick_duration_lose, 
			_min_tick_sec, 
			_max_tick_sec)
	print("Tick duration decreased to ", _curr_max_tick_duration)


func reset_tick_duration() -> void:
	_curr_max_tick_duration = _max_tick_sec
	print("Tick duration reset to ", _curr_max_tick_duration)


func start_a_tick() -> void:
	_tick_timer.start(_curr_max_tick_duration)
	print("\n==================================================")
	print("Tick started. Duration: ", _curr_max_tick_duration)


func pause_ticks(pause: bool) -> void:
	print("Ticks paused" if pause else "Ticks [UN]paused")
	_tick_timer.paused = pause


func stop_ticks() -> void:
	_tick_timer.stop()
	print("Ticks stopped.")


func _on_tick_timer_timeout() -> void:
	print("Tick timed out.")
	_state_machine.on_tick()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_state_machine.on_animation_finished(anim_name)
#endregion
