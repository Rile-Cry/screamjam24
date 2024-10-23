extends Control

@onready var controls_content = %controls_content
@onready var accessibility_content = %accessibility_content
@onready var audio_content = %audio_content
@onready var display_content = %display_content
@onready var back_button: TextureButton = %back_button
@onready var background: TextureRect = %Background
@onready var world_environment: WorldEnvironment = $WorldEnvironment


@onready var animation_player = $AnimationPlayer
@export var in_game_settings_menu:= false

func _ready() -> void:
	if in_game_settings_menu:
		back_button.pressed.connect(close_in_game_menu)
		# Start with mouse captured
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		background.visible = false
		world_environment.queue_free()
	else:
		back_button.pressed.connect(_on_back_button_pressed)
func _input(event: InputEvent) -> void:
	if in_game_settings_menu and event.is_action_pressed("toggle_settings_menu"):
		if visible:
			close_in_game_menu()
		else:
			open_in_game_menu()

func close_in_game_menu():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Engine.time_scale = 1
func open_in_game_menu():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Engine.time_scale = 0

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	pass # Replace with function body.


func _on_controls_button_pressed():
	animation_player.play("blood_trans")
	controls_content.visible = true
	accessibility_content.visible = false
	audio_content.visible = false
	display_content.visible = false
	pass # Replace with function body.


func _on_accessibility_button_pressed():
	animation_player.play("blood_trans")
	controls_content.visible = false
	accessibility_content.visible = true
	audio_content.visible = false
	display_content.visible = false
	pass # Replace with function body.


func _on_audio_button_pressed():
	animation_player.play("blood_trans")
	controls_content.visible = false
	accessibility_content.visible = false
	audio_content.visible = true
	display_content.visible = false
	pass # Replace with function body.


func _on_display_button_pressed():
	animation_player.play("blood_trans")
	controls_content.visible = false
	accessibility_content.visible = false
	audio_content.visible = false
	display_content.visible = true
	pass # Replace with function body.
