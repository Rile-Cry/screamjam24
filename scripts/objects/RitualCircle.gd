class_name RitualCircle
extends Node3D

var pedestal_list : Array[RitualPedestal]
var summoned := false

@onready var demon : PackedScene = preload("res://scenes/characters/demon.tscn")
@onready var demon_spawn := $DemonSpawn
@onready var spawn_sound: AudioStreamPlayer3D = $SpawnSound
@onready var pentagram_particles: GPUParticles3D = %PentagramParticles
@onready var spawn_light: OmniLight3D = %SpawnLight

func _ready() -> void:
	grab_pedestals()
	spawn_light.visible = false


func _process(delta) -> void:
	if Global.time > 1 and not summoned:
		if check_pedestals():
			spawn_light.visible = true
			spawn_light.light_energy = 0
			summoned = true
			spawn_sound.play()
			Camera.Instance.PlayShake(3,2)
			pentagram_particles.emitting = true

			var startingDensity := Camera.Instance.environment.volumetric_fog_density
			var vfxTween := create_tween().set_parallel(true)
			vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_density", 1.0,4.40)
			vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_albedo", Color.DIM_GRAY, 1)
			vfxTween.tween_property(spawn_light,"light_energy", 5, 6)

			await get_tree().create_timer(6).timeout
			spawn_light.visible = false
			Camera.Instance.environment.volumetric_fog_density = startingDensity
			Camera.Instance.environment.volumetric_fog_albedo = Color.WHITE
			MusicManager.change_to_demon_music()
			var demon_instance = demon.instantiate() as Demon
			get_tree().root.add_child(demon_instance)
			demon_instance.global_position = demon_spawn.global_position

			demon_instance.ritualCircle = self



func check_pedestals() -> bool:
	var check := true
	for pedestal in pedestal_list:
		check = pedestal.is_holding_item
		if check:
			break
		print(check)
		#check and pedestal.is_holding_item just for testing for 1 item
	return check


func grab_pedestals() -> void:
	for child in get_children():
		if is_instance_of(child, RitualPedestal):
			pedestal_list.append(child)
