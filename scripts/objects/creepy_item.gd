class_name CreepyItem
extends RigidBody3D

const POLTER_STRENGTH := 10.
var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.sanity < 75:
		creepy_proc(delta)


func creepy_proc(delta) -> void:
	if time > 1:
		if (randi() % 10) < 2:
		#if (randi() % 10000) < 24:
			polter()
		time = 0.
	
	time += delta

func polter() -> void:
	var dir = Vector3(randf_range(-1, 1), randf_range(0, 1), randf_range(-1, 1)).normalized()
	apply_central_impulse(dir * POLTER_STRENGTH)
