extends Control

const GAME_LEVEL = preload("res://scenes/levels/game_level.tscn")
@onready var play_button: Button = %play_button
@onready var options_button: Button = %options_button
@onready var credits_button: Button = %credits_button
@onready var quit_button: Button = %quit_button

func _ready() -> void:
	play_button.pressed.connect(new_game)
	quit_button.pressed.connect(quit)
func new_game():
	get_tree().change_scene_to_packed(GAME_LEVEL)

func quit():
	get_tree().quit()
