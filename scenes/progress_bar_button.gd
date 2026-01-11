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
		_on_warn_at_progress_set()
@export var disabled: bool:
	set(value):
		disabled = value
		_on_disabled_set()

@onready var _delayed_progress_bar := %DelayedProgressBar
@onready var _icon_texture_rect: TextureRect = %IconTextureRect
@onready var _texture_button: TextureButton = $TextureButton


func _ready() -> void:
	_on_icon_texture_set()
	_on_progress_set()


func set_progress_no_anim(value: int) -> void:
	_delayed_progress_bar.set_progress_no_anim(value)


func _on_icon_texture_set() -> void:
	if is_node_ready():
		_icon_texture_rect.texture = icon


func _on_progress_set() -> void:
	if is_node_ready():
		_delayed_progress_bar.progress = progress


func _on_disabled_set() -> void:
	if is_node_ready():
		_texture_button.disabled = disabled
		_texture_button.modulate.a = 0.2 if disabled else 1.0


func _on_texture_button_pressed() -> void:
	if not Engine.is_editor_hint():
		pressed.emit()


func _on_warn_at_progress_set() -> void:
	if is_node_ready():
		_delayed_progress_bar.warn_at_progress = warn_at_progress
