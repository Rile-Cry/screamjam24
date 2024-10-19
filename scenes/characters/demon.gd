extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var player: Player
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
func _physics_process(delta: float) -> void:
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


