extends Control


signal died
signal hunger_changed
signal dirty_changed
signal wear_changed


enum Status {
	DIRTY = 1,
	HUNGER = 2,
	WEAR = 4,
}

const MAX_STATUS_VALUE: int = 100
const WARN_VALUE: int = 70
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
var _tick_start_sec: float
var _tick_end_sec: float
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
@onready var _status_label: Label = $StatusLabel


func _ready() -> void:
	_status_label.hide()


func start_living() -> void:
	_reset_state()
	print("Pet started living.")
	_start_a_tick()


func get_hunger() -> int:
	return _hunger


func get_wear() -> int:
	return _wear


func get_dirt() -> int:
	return _dirt


func is_dead() -> bool:
	return _hunger >= MAX_STATUS_VALUE or _wear >= MAX_STATUS_VALUE or \
			_dirt >= MAX_STATUS_VALUE 


func is_worn_out() -> bool:
	return _wear > WARN_VALUE


func is_hungry() -> bool:
	return _hunger > WARN_VALUE


func is_dirty() -> bool:
	return _dirt > WARN_VALUE


func feed() -> void:
	if is_dead():
		return
	
	var reduction: int = randi_range(_min_hunger_reduction, _max_hunger_reduction)
	_hunger -= reduction
	_update_status_label()
	print("Fed. Reduction: ", reduction, " - Current val: ", _hunger)


func repair() -> void:
	if is_dead():
		return
	
	var reduction: int = randi_range(_min_wear_reduction, _max_wear_reduction)
	_wear -= reduction
	_update_status_label()
	print("Mantained. Reduction: ", reduction, " - Current val: ", _wear)


func clean() -> void:
	if is_dead():
		return
	
	var reduction: int = randi_range(_min_dirt_reduction, _max_dirt_reduction)
	_dirt -= reduction
	_update_status_label()
	print("Cleaned. Reduction: ", reduction, " - Current val: ", _dirt)


func _update_status_label() -> void:
	if is_dead():
		_status_label.text = "- DEAD -"
	elif is_worn_out():
		_status_label.text = "[ W ]ORN OUT"
	elif is_hungry():
		_status_label.text = "[ H ]UNGRY"
	elif is_dirty():
		_status_label.text = "[ D ]IRTY"
	else:
		_status_label.text = "Normal"


func _reset_state() -> void:
	print("Pet state reset.")
	_curr_max_tick_duration = _max_tick_sec
	_hunger = 0
	_wear = 0
	_dirt = 0
	_status_label.show()
	_update_status_label()


func _progress_difficulty() -> void:
	print("Making it more difficult.")
	var tick_duration_lose: float = \
			randf_range(0.0, _max_duration_lost_per_tick_sec)
	_curr_max_tick_duration = clampf(
			_curr_max_tick_duration - tick_duration_lose, 
			_min_tick_sec, 
			_max_tick_sec)
	print("New max tick duration is: %s (lost %s sec)" %
			[_curr_max_tick_duration, tick_duration_lose])


func _start_a_tick() -> void:
	var tick_duration_sec: float = randf_range(_min_tick_sec, _curr_max_tick_duration)
	_tick_start_sec = Time.get_unix_time_from_system()
	print("A new tick has started at %s. Duration: %s" % 
			[_tick_start_sec, tick_duration_sec])
	_tick_timer.start(tick_duration_sec)


func _damage() -> void:
	if is_dead():
		return
	
	var damaged_statuses: int = randi_range(0, 7)
	print("Damaging statuses: ", damaged_statuses)
	if damaged_statuses == 0:
		print("Took no damage.")
		return
	
	if damaged_statuses & Status.DIRTY:
		var damage: int = randi_range(_min_dirt_damage, _max_dirt_damage)
		_dirt += damage
		print("Took dirt damage: ", damage, " - Current val: ", _dirt)
	
	if damaged_statuses & Status.HUNGER:
		var damage: int = randi_range(_min_hunger_damage, _max_hunger_damage)
		_hunger += damage
		print("Took hunger damage: ", damage, " - Current val: ", _hunger)
	
	if damaged_statuses & Status.WEAR:
		var damage: int = randi_range(_min_wear_damage, _max_wear_damage)
		_wear += damage
		print("Took wear damage: ", damage, " - Current val: ", _wear)
	
	_update_status_label()
	
	if is_dead():
		_tick_timer.stop()
		died.emit()


func _on_tick_timer_timeout() -> void:
	_tick_end_sec = Time.get_unix_time_from_system()
	var tick_duration: float =  _tick_end_sec - _tick_start_sec
	print("Tick timed out at %s. Tick duration: %s" % [_tick_end_sec, tick_duration])
	print("Before state: [H: %s] - [W: %s] - [D: %s]" % [_hunger, _wear, _dirt])
	_damage()
	print("After state: [H: %s] - [W: %s] - [D: %s]" % [_hunger, _wear, _dirt])
	if is_dead():
		print("Pet is dead.")
		print("==================================\n")
	else:
		print("Pet is still alive!")
		print("==================================\n")
		_progress_difficulty()
		_start_a_tick()
