extends DirectionalLight2D


func _ready() -> void:
	_on_light_angle_changed()
	Settings.light_angle_changed.connect(_on_light_angle_changed)


func _on_light_angle_changed() -> void:
	rotation_degrees = -1 * Settings.get_light_angle() - 90
