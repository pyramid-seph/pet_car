# A TextureButton that emits a long_pressed after wait_time_sec seconds 
# of being held down.
# If action mode is set to ACTION_MODE_BUTTON_RELEASE, pressed will be emitted 
# immediately after long_pressed.
class_name LongPressTextureButton
extends TextureButton
# This is a pretty naive implementation, but it gets the job done.

signal long_pressed

@export_range(0.05, 10, 0.01, "or_greater") var wait_time_sec: float = 1.0

var _timer: Timer


func _init() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)


func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)
	button_down.connect(_on_button_button_down)
	button_up.connect(_on_button_button_up)


func _notification(what: int) -> void:
	if is_node_ready() and what == NOTIFICATION_UNPAUSED:
		_timer.stop()


func _on_button_button_down() -> void:
	_timer.start(wait_time_sec)


func _on_button_button_up() -> void:
	_timer.stop()


func _on_timer_timeout() -> void:
	long_pressed.emit()
