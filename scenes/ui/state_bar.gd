@tool
extends VBoxContainer


const BAR_COLOR_WARN: Color = Color("#306230")
const BAR_COLOR_NORMAL: Color = Color("#0f380f")

@export var icon: Texture2D:
	set(value):
		icon = value
		_on_icon_set()
@export var value: float:
	set(val):
		value = val
		_on_value_set()
@export var warn: bool:
	set(value):
		warn = value
		_on_warn_set()

@onready var _texture_rect: TextureRect = %TextureRect
@onready var _progress_bar: TextureProgressBar = %TextureProgressBar


func _ready() -> void:
	_on_icon_set()
	_on_value_set()
	_on_warn_set()


func _on_icon_set() -> void:
	if is_node_ready():
		_texture_rect.texture = icon


func _on_value_set() -> void:
	if is_node_ready():
		_progress_bar.value = value


func _on_warn_set() -> void:
	if is_node_ready():
		_progress_bar.tint_progress = \
				BAR_COLOR_WARN if warn else BAR_COLOR_NORMAL
