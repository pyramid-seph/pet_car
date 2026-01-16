class_name TwinkleTween
extends Node

@export
var _target_path: NodePath = ^".."
@export_range(0.0, 1.0, 0.01, "or_greater")
var _visible_direction_sec: float = 1.0
@export_range(0.0, 1.0, 0.01, "or_greater")
var _invisible_direction_sec: float = 0.25

var _tween: Tween

@onready var _target := get_node(_target_path) as CanvasItem


func _ready() -> void:
	if not _target:
		return
	
	if not _target.is_node_ready():
		await _target.ready
	
	_on_visibility_changed()
	_target.visibility_changed.connect(_on_visibility_changed)


func _start_animation() -> void:
	_stop_animation()
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(_target, "modulate:a", 1.0, 0.0).from(1.0)
	_tween.tween_interval(_visible_direction_sec)
	_tween.tween_property(_target, "modulate:a", 0.0, 0.0)
	_tween.tween_interval(_invisible_direction_sec)


func _stop_animation() -> void:
	if _tween:
		_tween.kill()
		_tween = null


func _on_visibility_changed() -> void:
	if not _target.is_node_ready():
		return
	
	if _target.visible:
		_start_animation()
	else:
		_stop_animation()
