extends Control

@onready var controls_content = %controls_content
@onready var accessibility_content = %accessibility_content
@onready var audio_content = %audio_content
@onready var display_content = %display_content

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	pass # Replace with function body.


func _on_controls_button_pressed():
	controls_content.visible = true
	accessibility_content.visible = false
	audio_content.visible = false
	display_content.visible = false
	pass # Replace with function body.


func _on_accessibility_button_pressed():
	controls_content.visible = false
	accessibility_content.visible = true
	audio_content.visible = false
	display_content.visible = false
	pass # Replace with function body.


func _on_audio_button_pressed():
	controls_content.visible = false
	accessibility_content.visible = false
	audio_content.visible = true
	display_content.visible = false
	pass # Replace with function body.


func _on_display_button_pressed():
	controls_content.visible = false
	accessibility_content.visible = false
	audio_content.visible = false
	display_content.visible = true
	pass # Replace with function body.
