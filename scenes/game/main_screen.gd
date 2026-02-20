extends Node


@onready var virtual_device: Sprite2D = %VirtualDevice


func _on_main_screen_ui_settings_panel_opened(available_space: Rect2) -> void:
	var device_size: Vector2 = virtual_device.get_rect().size
	var device_offset: Vector2 = device_size / 2.0
	virtual_device.position = available_space.position + \
			(available_space.size / 2.0) - device_offset
