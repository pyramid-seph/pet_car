extends TouchScreenButton


signal long_pressed

@export_range(0.05, 10, 0.01, "or_greater") var wait_time_sec: float = 1.0
@export var texture_hovered: Texture

var _timer: Timer


func _init() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)


func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)
	pressed.connect(_on_button_pressed)
	released.connect(_on_button_released)


func _notification(what: int) -> void:
	if is_node_ready() and what == NOTIFICATION_UNPAUSED:
		_timer.stop()


func _on_button_pressed() -> void:
	_timer.start(wait_time_sec)


func _on_button_released() -> void:
	_timer.stop()


func _on_timer_timeout() -> void:
	long_pressed.emit()
