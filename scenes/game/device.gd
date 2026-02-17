extends Sprite2D


func _ready() -> void:
	_apply_customizations()
	Settings.body_color_changed.connect(_on_body_color_changed)
	Settings.pattern_color_changed.connect(_on_pattern_color_changed)
	Settings.pattern_offset_changed.connect(_on_pattern_offset_changed)


# TODO This steals the input of the device buttons
#func _unhandled_input(event: InputEvent) -> void:
	#print("_input_event")
	#if event is InputEventMouseButton and event.is_pressed():
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#get_window().start_drag()


func _apply_customizations() -> void:
	_on_body_color_changed()
	_on_pattern_color_changed()
	_on_pattern_offset_changed()


func _on_body_color_changed() -> void:
	var shader := material as ShaderMaterial
	if not shader:
		return
	
	shader.set_shader_parameter("body_color", Settings.get_body_color())


func _on_pattern_color_changed() -> void:
	var shader := material as ShaderMaterial
	if not shader:
		return
	
	shader.set_shader_parameter("spots_color", Settings.get_pattern_color())



func _on_pattern_offset_changed() -> void:
	var shader := material as ShaderMaterial
	if not shader:
		return
	
	var pattern_offset: Vector2 = Settings.get_pattern_offset()
	shader.set_shader_parameter("spots_texture_offset_x", pattern_offset.x)
	shader.set_shader_parameter("spots_texture_offset_y", pattern_offset.y)
