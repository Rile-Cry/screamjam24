extends Control

const GAME_LEVEL = preload("res://scenes/levels/game_level.tscn")
@onready var play_button: Button = $BookMargin/book_cover/ButtonMargin/ButtonContainer/play_button
@onready var options_button: Button = $BookMargin/book_cover/ButtonMargin/ButtonContainer/options_button
@onready var credits_button: Button = $BookMargin/book_cover/ButtonMargin/ButtonContainer/credits_button
@onready var quit_button: Button = $BookMargin/book_cover/ButtonMargin/ButtonContainer/quit_button



func _ready() -> void:
	play_button.pressed.connect(new_game)
	quit_button.pressed.connect(quit)
	MusicManager.change_to_main_menu_music()
func new_game():
	get_tree().change_scene_to_packed(GAME_LEVEL)
	MusicManager.change_to_church_music()

func quit():
	get_tree().quit()
