extends Node


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

var _tick_start_sec: float
var _tick_end_sec: float

var _hunger: int:
	set(value):
		_hunger = clampi(value, MIN_STATUS_VALUE, MAX_STATUS_VALUE)
var _wear: int:
	set(value):
		_wear = clampi(value, MIN_STATUS_VALUE, MAX_STATUS_VALUE)
var _dirt: int:
	set(value):
		_dirt = clampi(value, MIN_STATUS_VALUE, MAX_STATUS_VALUE)

@onready var _tick_timer: Timer = $TickTimer


func _ready() -> void:
	_start_game()


func _process(_delta: float) -> void:
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/WearBar/TextureProgressBar.value = 100 - _wear
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/HungerBar/TextureProgressBar.value = 100 - _hunger
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/DirtBar/TextureProgressBar.value = 100 - _dirt
	
	if _is_dead():
		%StateLabel.text = "- DEAD -"
	elif _is_worn_out():
		%StateLabel.text = "[ W ]ORN OUT"
	elif _is_hungry():
		%StateLabel.text = "[ H ]UNGRY"
	elif _is_dirty():
		%StateLabel.text = "[ D ]IRTY"
	else:
		%StateLabel.text = "Normal"


func _start_game() -> void:
	print("Game started.")
	_start_a_tick()


func _start_a_tick() -> void:
	var tick_duration_sec: int = randi_range(_min_tick_sec, _max_tick_sec)
	_tick_start_sec = Time.get_unix_time_from_system()
	print("A new tick has started at %s. Duration: %s" % [_tick_start_sec, tick_duration_sec])
	_tick_timer.start(tick_duration_sec)


func _damage_pet() -> void:
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


func _feed_pet() -> void:
	var reduction: int = randi_range(_min_hunger_reduction, _max_hunger_reduction)
	_hunger -= reduction
	print("Fed. Reduction: ", reduction, " - Current val: ", _hunger)


func _repair_pet() -> void:
	var reduction: int = randi_range(_min_wear_reduction, _max_wear_reduction)
	_wear -= reduction
	print("Mantained. Reduction: ", reduction, " - Current val: ", _wear)


func _clean_pet() -> void:
	var reduction: int = randi_range(_min_dirt_reduction, _max_dirt_reduction)
	_dirt -= reduction
	print("Cleaned. Reduction: ", reduction, " - Current val: ", _dirt)


func _is_dead() -> bool:
	return _hunger >= MAX_STATUS_VALUE or _wear >= MAX_STATUS_VALUE or \
			_dirt >= MAX_STATUS_VALUE 


func _is_worn_out() -> bool:
	return _wear > WARN_VALUE


func _is_hungry() -> bool:
	return _hunger > WARN_VALUE


func _is_dirty() -> bool:
	return _dirt > WARN_VALUE


func _game_over() -> void:
	print("Game Over!")
	_tick_timer.stop()


func _on_tick_timer_timeout() -> void:
	_tick_end_sec = Time.get_unix_time_from_system()
	var tick_duration: float =  _tick_end_sec - _tick_start_sec
	print("Tick timed out at %s. Tick duration: %s" % [_tick_end_sec, tick_duration])
	print("Before state: [H: %s] - [W: %s] - [D: %s]" % [_hunger, _wear, _dirt])
	_damage_pet()
	print("After state: [H: %s] - [W: %s] - [D: %s]" % [_hunger, _wear, _dirt])
	if _is_dead():
		print("Pet is dead.")
		print("==================================\n")
		_game_over()
	else:
		print("Pet is still alive!")
		print("==================================\n")
		_start_a_tick()


func _on_repair_button_pressed() -> void:
	_repair_pet()


func _on_feed_button_pressed() -> void:
	_feed_pet()


func _on_clean_button_pressed() -> void:
	_clean_pet()
