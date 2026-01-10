@tool
extends Control
# FIXME progress 99 appears to be empty

signal pressed

const WARN_VALUE: int = 50

@export var icon: Texture2D:
	set(value):
		icon = value
		_on_icon_texture_set()
@export_range(0, 100) var progress: int:
	set(value):
		progress = clampi(value, 0, 100)
		_on_progress_set()
@export var disabled: bool:
	set(value):
		disabled = value
		_on_disabled_set()

@onready var _texture_progress_bar: TextureProgressBar = %TextureProgressBar
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
	
	_texture_progress_bar.value = progress
	var color = Color.RED if progress <= WARN_VALUE else Color.WHITE
	_texture_progress_bar.tint_progress = color


func _on_disabled_set() -> void:
	if is_node_ready():
		_texture_button.disabled = disabled
		_texture_button.modulate.a = 0.2 if disabled else 1.0


func _on_texture_button_pressed() -> void:
	if not Engine.is_editor_hint():
		pressed.emit()
