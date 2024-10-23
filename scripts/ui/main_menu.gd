extends Control


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")
	pass # Replace with function body.


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/credits_menu.tscn")
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
