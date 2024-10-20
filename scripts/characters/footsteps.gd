class_name FootstepsPlayer
extends AudioStreamPlayer3D

var lastStepPosition:= Vector3.ZERO

#dont set if not player
@export var player: Player

@export var stepSize := 2.0
@export var legWidth := 1.0
@export var footprintPrefab: PackedScene
@export var cameraShakeAmount := 0.0

var leftFootStep := false
var terrainMask: int
signal OnStep

func _ready() -> void:
	terrainMask = create_collision_mask([4])

func _physics_process(delta: float) -> void:
	var adjustedStepSize := stepSize
	if player and player.is_on_ladder:
		adjustedStepSize *=.4

	if lastStepPosition.distance_to(global_position) > adjustedStepSize:
		lastStepPosition = global_position
		play()
		drop_footprint()

		if cameraShakeAmount >0:
			Camera.Instance.PlayShake(cameraShakeAmount)
		OnStep.emit()

func get_step_percent_complete()->float:
	return lastStepPosition.distance_to(global_position)/stepSize

func drop_footprint():
	if !footprintPrefab:
		return
	var footprint := footprintPrefab.instantiate() as Node3D
	get_tree().current_scene.add_child(footprint)
	footprint.global_position = global_position
	footprint.global_rotation.y = global_rotation.y

	if leftFootStep:
		leftFootStep = false
		footprint.global_position += global_transform.basis.x *legWidth
		for child in footprint.get_children():
			if child is Sprite3D:
				child.scale.x *= -1
				return
	else:
		leftFootStep = true
		footprint.global_position -= global_transform.basis.x*legWidth




#raycasts so we know height of ground at that point
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(footprint.global_position + Vector3(0,1,0), footprint.global_position + Vector3(0, -100,0),terrainMask)
	var result := space_state.intersect_ray(query)
	if result:
		footprint.global_position.y = result.get("position").y




func create_collision_mask(layers):
	var mask = 0
	for layer in layers:
		mask |= 1 << (layer - 1)
	return mask



