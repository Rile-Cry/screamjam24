class_name Lightable
extends Interactable


@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var lighting_sound: AudioStreamPlayer3D = %LightingSound
@onready var extinguish_sound: AudioStreamPlayer3D = %ExtinguishSound
@onready var exhaust_timer: Timer = %ExhaustTimer

@export var timeCandleStaysLit := 10.0
var stayLit := false
var lightTween: Tween
@export var isLit := false
var startingEnergy:float

signal OnLit

func _ready() -> void:
	if timeCandleStaysLit == 0.:
		stayLit = true
	
	startingEnergy = omni_light_3d.light_energy
	if !isLit:
		omni_light_3d.light_energy = 0
	exhaust_timer.wait_time = timeCandleStaysLit

func interact():
	if lightTween and lightTween.is_running():
			return
	if interactable:

		if isLit:
			ExtinguishCandle()
		else:

			lightTween = create_tween()
			lightTween.tween_property(omni_light_3d,"light_energy",startingEnergy,2.).set_trans(Tween.TRANS_BOUNCE)
			isLit = true
			OnLit.emit()
			lighting_sound.play()
			exhaust_timer.start()
			interactable = false
			await lightTween.finished
			interactable = true
			interactDescription = "Extinguish"
	super.interact()


func ExtinguishCandle():
	if stayLit:
		return
	if lightTween and lightTween.is_running():
		lightTween.kill()


	lightTween = create_tween()
	lightTween.tween_property(omni_light_3d,"light_energy",0,.5).set_trans(Tween.TRANS_BOUNCE)
	isLit = false
	extinguish_sound.play()
	exhaust_timer.stop()
	interactable = false
	await lightTween.finished
	interactable = true
	interactDescription = "Light"

func change_color(color: Color, seconds:float):
	var colorTween := create_tween().set_trans(Tween.TRANS_BOUNCE)
	colorTween.tween_property(omni_light_3d,"light_color",color,seconds)
