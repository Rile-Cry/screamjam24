extends Area3D

@onready var cabinet: Node3D = $".."
@onready var slide_position: Node3D = $"../slidePosition"
@onready var open_sound: AudioStreamPlayer = $OpenSound

var isOpen:= false

func _on_body_entered(body: Node) -> void:
	if isOpen: return
	if body is Book:
		isOpen = true
		Global.checkpoints["picked_up_book"] = true
		OpenPassage()
func OpenPassage():
	var moveTween := create_tween()
	moveTween.tween_property(cabinet,"global_position",slide_position.global_position,7)
	Camera.Instance.PlayShake(.2,3)
	open_sound.play()
