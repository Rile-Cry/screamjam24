class_name CreepyItem
extends RigidBody3D

const POLTER_STRENGTH := 10.
var time := 0.0

@export var shift_list : Array[Vector3]

@onready var audio_player := $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	shift_list.append(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.sanity < 75:
		creepy_proc(delta)


func creepy_proc(delta) -> void:
	if time > 1:
		if (randi() % 10000) < ((100 - Global.sanity) * 4 - 76) and Global.sanity <= 75:
			polter()
		elif (randi() % 10000) < ((100 - Global.sanity) * 2 - 76) and Global.sanity <= 50:
			shifter()
		elif (randi() % 10000) < ((100 - Global.sanity) - 51) and Global.sanity <= 25:
			whispers()
		time = 0.

	time += delta

func polter() -> void:
	var dir = Vector3(randf_range(-1, 1), randf_range(0, 1), randf_range(-1, 1)).normalized()
	apply_central_impulse(dir * POLTER_STRENGTH)

func shifter() -> void:
	var shift = shift_list[randi() % shift_list.size()]
	position = shift

func whispers() -> void:
	audio_player.play()
