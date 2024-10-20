class_name Lightable
extends Interactable


@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var lighting_sound: AudioStreamPlayer3D = %LightingSound
@onready var extinguish_sound: AudioStreamPlayer3D = %ExtinguishSound

@export var canBeLitNow := true
var lightTween: Tween
@export var isLit := false
var startingEnergy:float

func _ready() -> void:
	startingEnergy = omni_light_3d.light_energy
	if !isLit:
		omni_light_3d.light_energy = 0

func interact():
	if lightTween and lightTween.is_running():
			return
	if canBeLitNow:
		lightTween = create_tween()
		if isLit:
			lightTween.tween_property(omni_light_3d,"light_energy",0,.5).set_trans(Tween.TRANS_BOUNCE)
			isLit = false
			extinguish_sound.play()
		else:
			lightTween.tween_property(omni_light_3d,"light_energy",startingEnergy,2.).set_trans(Tween.TRANS_BOUNCE)
			isLit = true
			lighting_sound.play()

	super.interact()
