extends CharacterBody3D

# Constants and Variables
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var colliding_obj = null
var name_ref = ""

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
		if colliding_obj != null and colliding_obj.type == colliding_obj.ItemType.PICKUP:
			pick_up()

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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

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
	if colliding_obj.get_parent() != null:
		colliding_obj.get_parent().remove_child(colliding_obj)
	hand.add_child(colliding_obj)
	colliding_obj.gravity_scale = 0
	colliding_obj.position = Vector3.ZERO

# ToDo: improve 'pickup' system after hearing back on inventory ideas
