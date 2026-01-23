class_name Utils
extends RefCounted


static func safe_connect(signal_object: Signal, callable: Callable,
		flags: int = 0) -> void:
	if not signal_object.is_connected(callable):
		signal_object.connect(callable, flags)


static func safe_disconnect(signal_object: Signal, callable: Callable) -> void:
	if signal_object.is_connected(callable):
		signal_object.disconnect(callable)
