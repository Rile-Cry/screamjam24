class_name AtmosphericZone
extends Area3D

@export_range(0,1) var room_size: float = 1.0
@export_range(0,1) var wall_hardness: float = 0.5
@export_range(0,1) var wet_volume: float = 0.5
@export var ouside_db_adjust: float = -15.0
@export var ouside_cutoff_hz: int = 700

@export var fog_density:= .05

var environment = preload("res://visuals/environments/Volumetric environment.tres")
var fog_starting_density:float
static var currentAtmosphericZoneIn: AtmosphericZone
static var transitionSpeed := .3
static var transitionTween: Tween

#bus effect references
var reverbEffect: AudioEffectReverb
var outsideLowPass: AudioEffectLowPassFilter

func _ready() -> void:
	reverbEffect = AudioServer.get_bus_effect(2,0)
	outsideLowPass = AudioServer.get_bus_effect(3,0)
	fog_starting_density = environment.volumetric_fog_density
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		currentAtmosphericZoneIn = self
		transition_into()

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		if currentAtmosphericZoneIn and currentAtmosphericZoneIn == self:
			currentAtmosphericZoneIn = null
			transition_out()

func transition_into():
	if transitionTween:
		transitionTween.kill()
	transitionTween = create_tween().set_parallel(true)
	transitionTween.tween_property(reverbEffect,"room_size",room_size,transitionSpeed)
	transitionTween.tween_property(reverbEffect,"damping",wall_hardness,transitionSpeed)
	transitionTween.tween_property(reverbEffect,"wet",wet_volume,transitionSpeed)
	transitionTween.tween_property(outsideLowPass,"cutoff_hz",ouside_cutoff_hz,transitionSpeed)
	transitionTween.tween_property(environment,"volumetric_fog_density",fog_density,transitionSpeed)


func transition_out():
	if transitionTween:
		transitionTween.kill()
	transitionTween = create_tween().set_parallel(true)
	transitionTween.tween_property(reverbEffect,"room_size",0,transitionSpeed)
	transitionTween.tween_property(reverbEffect,"damping",0,transitionSpeed)
	transitionTween.tween_property(reverbEffect,"wet",0,transitionSpeed)
	transitionTween.tween_property(outsideLowPass,"cutoff_hz",10000,transitionSpeed)
	transitionTween.tween_property(environment,"volumetric_fog_density",fog_starting_density,transitionSpeed)

