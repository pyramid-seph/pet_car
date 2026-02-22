extends Sprite2D


enum Condition {
	DEFAULT,
	HUNGRY,
}

const PET_CAR_BODY_EYES_BLINK: AtlasTexture = preload("uid://jtcjaut3misx")
const PET_CAR_BODY_EYES_DEFAULT: AtlasTexture = preload("uid://dbnrj3lsnugge")
const PET_CAR_BODY_EYES_HAPPY: AtlasTexture = preload("uid://ccxlg1ht0ouv6")
const PET_CAR_BODY_EYES_HUNGRY: AtlasTexture = preload("uid://bfu8wnykk7cny")

const MIN_BLINK_DURATION: float = 0.2
const MAX_BLINK_DURATION: float = 1.0
const MIN_DURATION_SEC: float = 1.0

@export_range(MIN_DURATION_SEC, 5.0, 0.1, "or_greater")
var max_time_between_blinks_sec: float = 1.0
@export
var condition: Condition:
	set(value):
		condition = value
		_on_condition_set()

var _is_blinking: bool

@onready var _timer: Timer = $Timer


func _ready() -> void:
	_is_blinking = false
	_update_eye_texture()
	_start_timer()


func _update_eye_texture() -> void:
	if _is_blinking:
		texture = PET_CAR_BODY_EYES_BLINK
	else:
		match condition:
			Condition.HUNGRY:
				texture = PET_CAR_BODY_EYES_HUNGRY
			_:
				texture = PET_CAR_BODY_EYES_DEFAULT


func _start_timer() -> void:
	var duration: float = 0.0
	if _is_blinking:
		duration = randf_range(MIN_BLINK_DURATION, MAX_BLINK_DURATION)
	else:
		duration = randf_range(MIN_DURATION_SEC, max_time_between_blinks_sec)
	_timer.start(duration)


func _on_condition_set() -> void:
	if is_node_ready():
		_update_eye_texture()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	_is_blinking = false
	_update_eye_texture()
	_start_timer()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_timer.stop()


func _on_timer_timeout() -> void:
	_is_blinking = !_is_blinking
	_update_eye_texture()
	_start_timer()
