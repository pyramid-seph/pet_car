extends Node

@onready var _pet := %Pet
@onready var _repair_progress_bar_button := %RepairProgressBarButton
@onready var _feed_progress_bar_button := %FeedProgressBarButton
@onready var _clean_progress_bar_button := %CleanProgressBarButton


func _ready() -> void:
	_repair_progress_bar_button.disabled = true
	_feed_progress_bar_button.disabled = true
	_clean_progress_bar_button.disabled = true
	
	_on_pet_wear_changed()
	_on_pet_hunger_changed()
	_on_pet_dirty_changed()
	_start_game()


func _start_game() -> void:
	print("Game started.")
	print("==================================\n")
	_pet.start_living()
	_repair_progress_bar_button.disabled = false
	_feed_progress_bar_button.disabled = false
	_clean_progress_bar_button.disabled = false


func _game_over() -> void:
	print("Game over.")


func _on_repair_progress_bar_button_pressed() -> void:
	_pet.repair()


func _on_feed_progress_bar_button_pressed() -> void:
	_pet.feed()


func _on_clean_progress_bar_button_pressed() -> void:
	_pet.clean()


func _on_pet_died() -> void:
	_game_over()
	_repair_progress_bar_button.disabled = true
	_feed_progress_bar_button.disabled = true
	_clean_progress_bar_button.disabled = true


func _on_pet_wear_changed() -> void:
	_repair_progress_bar_button.progress = 100 - _pet.get_wear()


func _on_pet_hunger_changed() -> void:
	_feed_progress_bar_button.progress = 100 - _pet.get_hunger()


func _on_pet_dirty_changed() -> void:
	_clean_progress_bar_button.progress = 100 - _pet.get_dirt()
