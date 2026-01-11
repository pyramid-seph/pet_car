@tool
extends Control
# FIXME progress 99 appears to be empty

signal pressed

@export var icon: Texture2D:
	set(value):
		icon = value
		_on_icon_texture_set()
@export_range(0, 100) var progress: int:
	set(value):
		progress = clampi(value, 0, 100)
		_on_progress_set()
@export_range(0, 100) var warn_at_progress: int = 30:
	set(value):
		warn_at_progress = clampi(value, 0, 100)
		# Not a typo. This should trigger a redraw of the progress bar.
		_on_progress_set()
@export var disabled: bool:
	set(value):
		disabled = value
		_on_disabled_set()

var _progress_reduction_tween: Tween

@onready var _delayed_progress_bar: TextureProgressBar = %DelayedTextureProgressBar
@onready var _actual_progress_bar: TextureProgressBar = %ActualTextureProgressBar
@onready var _icon_texture_rect: TextureRect = %IconTextureRect
@onready var _texture_button: TextureButton = $TextureButton


func _ready() -> void:
	_on_icon_texture_set()
	_on_progress_set()


func _on_icon_texture_set() -> void:
	if is_node_ready():
		_icon_texture_rect.texture = icon


func _on_progress_set() -> void:
	if not is_node_ready():
		return
	
	if Engine.is_editor_hint():
		_delayed_progress_bar.value = progress
	else:
		if _progress_reduction_tween:
			_progress_reduction_tween.kill()
		_progress_reduction_tween = create_tween()
		_progress_reduction_tween.tween_property(
				_delayed_progress_bar,
				"value", 
				progress, 
				0.05
		).set_delay(0.25)
	
	_actual_progress_bar.value = progress
	var color = Color.RED if progress <= warn_at_progress else Color.WHITE
	_actual_progress_bar.tint_progress = color


func _on_disabled_set() -> void:
	if is_node_ready():
		_texture_button.disabled = disabled
		_texture_button.modulate.a = 0.2 if disabled else 1.0


func _on_texture_button_pressed() -> void:
	if not Engine.is_editor_hint():
		pressed.emit()
