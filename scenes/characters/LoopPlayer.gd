extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(on_finished)


func on_finished():
	play()
