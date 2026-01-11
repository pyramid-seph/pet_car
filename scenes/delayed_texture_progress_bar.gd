@tool
extends Control


@export_range(0, 100) var progress: int:
	set(value):
		_old_progress_value = progress
		progress = clampi(value, 0, 100)
		_on_progress_set()
@export_range(0, 100) var warn_at_progress: int = 25:
	set(value):
		warn_at_progress = clampi(value, 0, 100)
		_on_warn_at_progress_set()
@export_range(0.05, 1, 0.01) var change_anim_delay_sec: float = 0.25
@export_range(0.05, 1, 0.01) var change_anim_duration_sec: float = 0.05
@export var normal_tint: Color = Color.WHITE
@export var warning_tint: Color = Color.RED
@export var increment_tint: Color = Color.BLUE
@export var decrement_tint: Color = Color.YELLOW

var _old_progress_value: int
var _progress_tween: Tween

@onready var _back_progress_bar: TextureProgressBar = %BackTextureProgressBar
@onready var _front_progress_bar: TextureProgressBar = %FrontTextureProgressBar


func _ready() -> void:
	_update_progress_bar_no_anim()


func _get_progress_color() -> Color:
	return warning_tint if progress <= warn_at_progress else normal_tint


func _update_progress_bar_no_anim() -> void:
	_back_progress_bar.value = progress
	_front_progress_bar.value = progress
	var progress_color: Color = _get_progress_color()
	_back_progress_bar.tint_progress = progress_color
	_front_progress_bar.tint_progress = progress_color


func _tween_bar_value_to_curr_progress(bar: TextureProgressBar) -> void:
	if _progress_tween:
		_progress_tween.kill()
	_progress_tween = create_tween()
	_progress_tween.tween_property(
			bar,
			"value", 
			progress, 
			change_anim_duration_sec
	).set_delay(change_anim_delay_sec)


func _animate_decrement() -> void:
	_back_progress_bar.tint_progress = decrement_tint
	_tween_bar_value_to_curr_progress(_back_progress_bar)
	_front_progress_bar.value = progress


func _animate_increment() -> void:
	_back_progress_bar.tint_progress = increment_tint
	_back_progress_bar.value = progress
	_tween_bar_value_to_curr_progress(_front_progress_bar)


func _animate_progress_change() -> void:
	if _old_progress_value > progress:
		_animate_decrement()
	elif _old_progress_value < progress:
		_animate_increment()


func _on_progress_set() -> void:
	if not is_node_ready():
		return
	
	if Engine.is_editor_hint():
		_update_progress_bar_no_anim()
	else:
		_animate_progress_change()


func _on_warn_at_progress_set() -> void:
	if is_node_ready():
		_front_progress_bar.tint_progress = _get_progress_color()


func _on_front_texture_progress_bar_value_changed(_value: float) -> void:
	_front_progress_bar.tint_progress = _get_progress_color()
