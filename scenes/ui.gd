extends Control


@onready var _repair_progress_bar_button := %RepairProgressBarButton
@onready var _feed_progress_bar_button := %FeedProgressBarButton
@onready var _clean_progress_bar_button := %CleanProgressBarButton
@onready var _press_any_button_container: VBoxContainer = %PressAnyButtonContainer
@onready var _turn_off_instructions_container := %TurnOffInstructionsContainer


func update_wear(value: int) -> void:
	var new_val: int = 100 - value
	if new_val > 0 and new_val < 5:
		new_val = 5
	_repair_progress_bar_button.progress = new_val


func update_wear_no_anim(value: int) -> void:
	var new_val: int = 100 - value
	if new_val > 0 and new_val < 5:
		new_val = 5
	_repair_progress_bar_button.set_progress_no_anim(new_val)


func update_hunger(value: int) -> void:
	var new_val: int = 100 - value
	if new_val > 0 and new_val < 5:
		new_val = 5
	_feed_progress_bar_button.progress = new_val


func update_hunger_no_anim(value: int) -> void:
	var new_val: int = 100 - value
	if new_val > 0 and new_val < 5:
		new_val = 5
	_feed_progress_bar_button.set_progress_no_anim(new_val)


func update_dirt(value: int) -> void:
	var new_val: int = 100 - value
	if new_val > 0 and new_val < 5:
		new_val = 5
	_clean_progress_bar_button.progress = new_val


func update_dirt_no_anim(value: int) -> void:
	var new_val: int = 100 - value
	if new_val > 0 and new_val < 5:
		new_val = 5
	_clean_progress_bar_button.set_progress_no_anim(new_val)


func show_press_any_button_indicator() -> void:
	_press_any_button_container.show()


func hide_press_any_button_indicator() -> void:
	_press_any_button_container.hide()


func show_turn_off_instructions() -> void:
	_turn_off_instructions_container.show()


func hide_turn_off_instructions() -> void:
	_turn_off_instructions_container.hide()
