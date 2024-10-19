class_name Camera
extends Camera3D

static var Instance: Camera
@onready var camera_shake: ShakerComponent3D = %CameraShake

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Instance = self

func PlayShake(intensity: float, duration := .2):
	if camera_shake.is_playing and camera_shake.intensity > intensity:
		return
	camera_shake.intensity = intensity
	camera_shake.duration = duration
	camera_shake.play_shake()
