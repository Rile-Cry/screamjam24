extends Control

@onready var settings_menu: Control = $SettingsMenu


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
	pass # Replace with function body.
