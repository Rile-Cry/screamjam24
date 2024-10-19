class_name Player
extends CharacterBody3D

# Constants and Variables
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const STEP_HEIGHT := 0.1
var colliding_obj :Interactable= null
var name_ref = ""

@export var drop_dist := 1.25

# Child Node references
var camera : Camera3D
var hand : Node3D
var ray : RayCast3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Setting node references
	camera = $Camera3D
	hand = $Camera3D/Hand
	ray = $Camera3D/RayCast3D

	# Start with mouse captured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Basic "pause", as in if the player's screen moves.
	# Will change to a full pause functionality later.
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(event.relative.x * -0.001)
			camera.rotate_x(event.relative.y * -0.001)

	# Basic Interaction with objects, currently only picks up and crudely at that
	if event.is_action_pressed("interact"):
		if colliding_obj != null:
			match colliding_obj.type:
				colliding_obj.ItemType.PICKUP:
					pick_up()
				colliding_obj.ItemType.INTERACT:
					colliding_obj.interact()
	
	if event.is_action_pressed("drop"):
		drop()


func _physics_process(delta):
	movement(delta)

func _process(_delta):
	check_ray()

# _physics_process methods
func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Input.is_action_pressed("run"):
			velocity *= 1.5
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


#makes camera move with steps, might delete this later, im not convinced we neeed it
	camera.position.y = move_toward(camera.position.y,1.6 +  footsteps_player.get_step_percent_complete()* STEP_HEIGHT,delta*.3)


@onready var footsteps_player: FootstepsPlayer = $FootstepsPlayer
# _process methods
func check_ray():
	# Make sure the ray is colliding before grabbing collision obj (layer 3: items)
	if ray.is_colliding():
		colliding_obj = ray.get_collider()
		if colliding_obj.has_method("mouse_entered"):
			colliding_obj.mouse_entered()
	elif colliding_obj != null:
		if colliding_obj.has_method("mouse_exited"):
			colliding_obj.mouse_exited()

# other methods
func pick_up():
	# Crude pickup method :: will look very different.
	drop()
	if colliding_obj.get_parent() != null:
		colliding_obj.get_parent().remove_child(colliding_obj)
	hand.add_child(colliding_obj)
	colliding_obj.process_mode =Node.PROCESS_MODE_DISABLED
	colliding_obj.position = Vector3.ZERO
	colliding_obj.rotation = hand.rotation

func drop():
	if hand.get_child_count() > 1:
		var hand_item = hand.get_child(1)
		hand.remove_child(hand_item)
		get_parent().add_child(hand_item)
		var theta = rotation.y
		var offset = Vector3(-drop_dist * sin(theta), 0, -drop_dist * cos(theta))
		hand_item.global_position = hand.global_position + offset
		hand_item.process_mode = Node.PROCESS_MODE_ALWAYS

# ToDo: improve 'pickup' system after hearing back on inventory ideas
