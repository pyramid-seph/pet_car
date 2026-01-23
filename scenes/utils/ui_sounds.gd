class_name UiSounds
extends Node


@export var _root_path: NodePath = ^".."
@export var _max_depth: int = 16:
	set(value):
		_max_depth = maxi(value, 1)
@export var pressed_sound: AudioStream


func _ready() -> void:
	var root_node: Node = get_node(_root_path)
	_install_control_ui_sounds(root_node)


func _play_sound(sound: AudioStream) -> void:
	if sound:
		SoundManager.play_ui_sound(sound)


func _connect_signals(node: Control) -> void:
	if node and node is BaseButton and \
			not node.is_in_group("sound_manager_exclude"):
		Utils.safe_connect(node.pressed, _play_sound.bind(pressed_sound))


func _install_control_ui_sounds(parent_node: Node, depth: int = 0) -> void:
	if not parent_node or parent_node is UiSounds:
		if parent_node != self:
			var parent_node_parent: Node = parent_node.get_parent()
			if parent_node_parent:
				Log.w("Another UiSound is in: ", parent_node_parent.name)
		return
	
	if depth >= _max_depth:
		Log.w("%s has reached max depth (%s)" % [name, _max_depth])
		return
	
	for child_node: Node in parent_node.get_children():
		_connect_signals(child_node as Control)
		_install_control_ui_sounds(child_node, depth + 1)
