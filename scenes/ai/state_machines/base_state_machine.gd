@abstract
class_name BaseStateMachine
extends Node


@export var _subject_node_path: NodePath = ^".."
@export var autostart: bool

var _initial_state: BaseState
var _previous_state: BaseState
var _current_state: BaseState

@onready var _subject: Node = get_node(_subject_node_path)


func _ready() -> void:
	if not _subject:
		return
	
	for idx: int in get_child_count():
		var child := get_child(idx) as BaseState
		if child and not _initial_state:
			_initial_state = child
			break
	
	if not _initial_state:
		return
	
	if not _subject.is_node_ready():
		await _subject.ready
	
	if autostart:
		start()


func set_initial_state(state_name: String) -> void:
	_initial_state = get_node(state_name) as BaseState


func set_previous_state(state_name: String) -> void:
	_previous_state = get_node(state_name) as BaseState


func set_current_state(state_name: String) -> void:
	_current_state = get_node(state_name) as BaseState


func start() -> void:
	_previous_state = null
	if _initial_state:
		change_state(_initial_state.get_path())
	else:
		_current_state = null


func get_subject() -> Node:
	return _subject


func get_current_state() -> BaseState:
	return _current_state


func change_state(state_name: String) -> void:
	if not has_node(state_name):
		return
	
	_previous_state = _current_state
	if _current_state:
		_current_state.exit(_subject)
	_current_state = get_node(state_name) as BaseState
	if _current_state:
		_current_state.enter(_subject)


func revert_to_previous_state() -> void:
	if _previous_state:
		change_state(_previous_state.get_path())


func is_in_state(state_name: String) -> bool:
	return false if not _current_state else _current_state.name == state_name
