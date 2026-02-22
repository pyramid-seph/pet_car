class_name EventTextureButton
extends TextureButton


@export_custom(PROPERTY_HINT_INPUT_NAME, "")
var action: StringName


func _ready() -> void:
	button_up.connect(_on_button_up)
	button_down.connect(_on_button_down)


func _on_button_up() -> void:
	var button_release_event := InputEventAction.new()
	button_release_event.action = action
	button_release_event.pressed = false
	Input.parse_input_event(button_release_event)


func _on_button_down() -> void:
	var button_press_event := InputEventAction.new()
	button_press_event.action = action
	button_press_event.pressed = true
	Input.parse_input_event(button_press_event)
