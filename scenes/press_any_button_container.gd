extends VBoxContainer


var _tween: Tween

@onready var _label: Label = $Label

func _ready() -> void:
	_on_visibility_changed()


func _start_animation() -> void:
	_stop_animation()
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(_label, "modulate:a", 1.0, 0.0).from(1.0)
	_tween.tween_interval(1.0)
	_tween.tween_property(_label, "modulate:a", 0.0, 0.0)
	_tween.tween_interval(0.25)


func _stop_animation() -> void:
	if _tween:
		_tween.kill()
		_tween = null


func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
	
	if visible:
		_start_animation()
	else:
		_stop_animation()
