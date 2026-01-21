extends Control


@onready var _repair_progress_bar_button := %RepairProgressBarButton
@onready var _feed_progress_bar_button := %FeedProgressBarButton
@onready var _clean_progress_bar_button := %CleanProgressBarButton
@onready var _press_any_button_label: Label = %PressAnyButtonLabel
@onready var _turn_off_instructions_container := %TurnOffInstructionsContainer
@onready var _wear_texture_rect: TextureRect = %WearTextureRect
@onready var _wear_progress_bar: TextureProgressBar = %WearProgressBar
@onready var _hunger_texture_rect: TextureRect = %HungerTextureRect
@onready var _hunger_progress_bar: TextureProgressBar = %HungerProgressBar
@onready var _dirt_texture_rect: TextureRect = %DirtTextureRect
@onready var _dirt_progress_bar: TextureProgressBar = %DirtProgressBar
@onready var _bars_container: HBoxContainer = %BarsContainer


func update_wear(value: int, warn: bool) -> void:
	_wear_progress_bar.value = 100 - value
	# TODO Change to warn state


func update_hunger(value: int, warn: bool) -> void:
	_hunger_progress_bar.value = 100 - value
	# TODO Change to warn state


func update_dirt(value: int, warn: bool) -> void:
	_dirt_progress_bar.value = 100 - value
	# TODO Change to warn state


func show_state_bars() -> void:
	_bars_container.modulate.a = 1.0


func hide_state_bars() -> void:
	_bars_container.modulate.a = 0.0


func show_press_any_button_indicator() -> void:
	_press_any_button_label.show()


func hide_press_any_button_indicator() -> void:
	_press_any_button_label.hide()


func show_turn_off_instructions() -> void:
	_turn_off_instructions_container.show()


func hide_turn_off_instructions() -> void:
	_turn_off_instructions_container.hide()
