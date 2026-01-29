extends Label


const MONTH_NAMES_SMALL: Array[String] = ["JAN", "FEB", "MAR", "APR", "MAY",
		"JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_update_clock()


func _notification(what: int) -> void:
	if is_node_ready() and what == NOTIFICATION_TRANSLATION_CHANGED:
		_update_clock()


func _process(_delta: float) -> void:
	if Engine.get_process_frames() % 100 == 0:
		_update_clock()


func _get_month_name_small(month: int) -> String:
	if month < 1 or month > MONTH_NAMES_SMALL.size():
		return "??"
	
	return tr(MONTH_NAMES_SMALL[month - 1])


func _update_clock() -> void:
	var datetime := Time.get_datetime_dict_from_system()
	
	text = "%s %s, %02d:%02d" % [_get_month_name_small(datetime.month), 
			datetime.day, datetime.hour, datetime.minute]
