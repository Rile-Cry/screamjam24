extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_settings_menu"):
		visible = !visible
