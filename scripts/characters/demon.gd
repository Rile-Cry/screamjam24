
class_name Demon
extends CharacterBody3D


const JUMP_VELOCITY = 4.5
const SPEED = 3.0
var player: Player
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var pauseBeforeMove := 5.0
@export var pauseBeforeCanDamagePlayer := 5.0
@onready var knockback_field: DemonKnockbackField = $KnockbackField


var isMoving := false
var ritualCircle: RitualCircle
static var spawnedInstance : Demon
const sanityDrainPerSecondWhileDemonIsAlive := 2.0
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	await get_tree().create_timer(pauseBeforeMove).timeout
	isMoving = true
	spawnedInstance = self
	Global.sanity_list[get_instance_id()] = -sanityDrainPerSecondWhileDemonIsAlive
	await get_tree().create_timer(pauseBeforeCanDamagePlayer).timeout
	knockback_field.canDamagePlayer = true


func _physics_process(delta: float) -> void:
	if !isMoving:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	var direction := global_position.direction_to(player.global_position)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var lookPosition := player.global_position
	lookPosition.y = global_position.y
	look_at(lookPosition)
	move_and_slide()

func reset_ritual():
	for pedistal in ritualCircle.pedestal_list:
		pedistal.drop_item()
	ritualCircle.summoned = false
	MusicManager.change_to_church_music()
	spawnedInstance = null
	Global.sanity_list.erase(get_instance_id())
	queue_free()
