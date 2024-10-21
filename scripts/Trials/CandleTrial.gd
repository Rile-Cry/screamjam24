extends Node3D

signal OnTrialPassed
@export var finishedColor :Color
@onready var finished_sound: AudioStreamPlayer = %FinishedSound
@onready var item_pop_sound: AudioStreamPlayer = %ItemPopSound
@export var itemToAppearWhenTrialIsPassed :Node3D
var passed := false


func _ready() -> void:
	for child in get_children():
		if child is Lightable:
			child.OnLit.connect(OnCandleLit)
	itemToAppearWhenTrialIsPassed.visible = false
	itemToAppearWhenTrialIsPassed.process_mode =Node.PROCESS_MODE_DISABLED

func OnCandleLit():
	if passed:
		return
	for child in get_children():
		if child is Lightable and !child.isLit:
			return
# if all children are lit
	TrialPassed()

func TrialPassed():
	passed = true

	for child in get_children():
		if child is Lightable:
			child.stayLit = true
			child.change_color(finishedColor,6)
	await get_tree().create_timer(1).timeout
	finished_sound.play()
	var startingDensity := Camera.Instance.environment.volumetric_fog_density
	var vfxTween := create_tween().set_parallel(true)
	vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_density", 1.0,4.40)
	vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_albedo", Color.DIM_GRAY, 1)
	await get_tree().create_timer(2).timeout
	item_pop_sound.play()
	Camera.Instance.PlayShake(1,2)
	await get_tree().create_timer(2.41).timeout
	Camera.Instance.environment.volumetric_fog_density = startingDensity
	Camera.Instance.environment.volumetric_fog_albedo = Color.WHITE
	itemToAppearWhenTrialIsPassed.visible = true
	itemToAppearWhenTrialIsPassed.process_mode = Node.PROCESS_MODE_INHERIT

