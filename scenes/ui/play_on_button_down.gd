class_name PlayOnButtonDown
extends Node


@export var button_path: NodePath = ^".."
@export var sound: AudioStream


func _ready() -> void:
	var button := get_node(button_path) as BaseButton
	if button:
		Utils.safe_connect(button.button_down, _on_button_down)


func _on_button_down() -> void:
	if sound:
		SoundManager.play_sound(sound)
