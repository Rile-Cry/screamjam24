class_name FootstepsPlayer
extends AudioStreamPlayer3D

var lastStepPosition:= Vector3.ZERO
static var stepSize := 2.0

func _physics_process(delta: float) -> void:
	if lastStepPosition.distance_to(global_position) > stepSize:
		lastStepPosition = global_position
		play()
