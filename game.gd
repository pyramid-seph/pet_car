extends Node

@onready var _pet := %Pet

func _ready() -> void:
	_start_game()


func _start_game() -> void:
	print("Game started.")
	print("==================================\n")
	_pet.start_living()


func _game_over() -> void:
	print("Game over.")


func _on_repair_button_pressed() -> void:
	_pet.repair()


func _on_feed_button_pressed() -> void:
	_pet.feed()


func _on_clean_button_pressed() -> void:
	_pet.clean()


func _on_pet_died() -> void:
	_game_over()


func _on_pet_wear_changed() -> void:
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/WearBar/TextureProgressBar.value = 100 - _pet.get_wear()


func _on_pet_hunger_changed() -> void:
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/HungerBar/TextureProgressBar.value = 100 - _pet.get_hunger()


func _on_pet_dirty_changed() -> void:
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/DirtBar/TextureProgressBar.value = 100 - _pet.get_dirt()
