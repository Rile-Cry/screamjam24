class_name Player
extends CharacterBody3D

# Constants and Variables
const CLIMB_SPEED := 2.0
const SPEED := 5.0
const STEP_HEIGHT := 0.1
const THROW_SPEED := 25.0
var climbing := false
var colliding_obj : Interactable
var is_on_ladder := false
var max_pitch := deg_to_rad(89)
var min_pitch := deg_to_rad(-89)
var name_ref := ""
var pitch := 0.0
var sanity := 100.0
var currentReadingItem: Readable
@export var drop_dist := 1.25

# Child Node references
@onready var camera := $Camera3D
@onready var collider := $CollisionShape3D
@onready var main_hand := $Camera3D/MainHand
@onready var off_hand := $Camera3D/OffHand
@onready var ray := $Camera3D/RayCast3D
@onready var reading_position: Node3D = %ReadingPosition


# Project Setting References
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree() -> void:
	add_to_group("player")
func _ready():
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

			pitch -= event.relative.y * 0.001
			pitch = clamp(pitch, min_pitch, max_pitch)
			camera.rotation.x = pitch

	# Basic Interaction with objects, currently only picks up and crudely at that
	if event.is_action_pressed("interact"):
		if currentReadingItem:
			Global.AddNote(currentReadingItem.noteResource)
			currentReadingItem.queue_free()
			currentReadingItem = null
			return

		if colliding_obj != null:
			match colliding_obj.type:
				colliding_obj.ItemType.PICKUP:
					pick_up()
				colliding_obj.ItemType.INTERACT:
					colliding_obj.interact()
				colliding_obj.ItemType.READABLE:
					read()

	if event.is_action_pressed("stop_climbing"):
		if is_on_ladder:
			climbing = false

	if event.is_action_pressed("drop"):
		drop()

	if event.is_action_pressed("throw"):
		drop(true)

	if event.is_action_pressed("hand_switch"):
		switch_hands()


func _physics_process(delta) -> void:
	if is_on_ladder and climbing:
		climb_ladder(delta)
	else:
		movement(delta)


func _process(_delta) -> void:
	check_ray()


# _physics_process methods
func movement(delta) -> void:
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


func climb_ladder(delta):
	# Basic Climb Ability :: already have another idea in mind to improve but as a start.
	var input_dir = Input.get_axis("move_backward", "move_forward")
	velocity.y = input_dir * CLIMB_SPEED

	move_and_slide()


@onready var footsteps_player: FootstepsPlayer = $FootstepsPlayer
# _process methods
func check_ray() -> void:
	# Make sure the ray is colliding before grabbing collision obj (layer 3: items)
	if ray.is_colliding():
		colliding_obj = ray.get_collider()
		if colliding_obj.has_method("mouse_entered"):
			colliding_obj.mouse_entered()
	elif colliding_obj != null:
		if colliding_obj.has_method("mouse_exited"):
			colliding_obj.mouse_exited()


# other methods
func pick_up() -> void:
	# Crude pickup method :: will look very different.
	drop()
	if colliding_obj.get_parent() != null:
		colliding_obj.get_parent().remove_child(colliding_obj)
	if is_instance_of(colliding_obj, Book):
		Global.is_holding_book = true
	main_hand.add_child(colliding_obj)
	colliding_obj.linear_velocity = Vector3.ZERO
	colliding_obj.process_mode = Node.PROCESS_MODE_DISABLED
	colliding_obj.position = Vector3.ZERO
	colliding_obj.rotation = main_hand.rotation

func read() ->void:
	if colliding_obj.type != Interactable.ItemType.READABLE:
		return
	colliding_obj.process_mode = Node.PROCESS_MODE_DISABLED
	colliding_obj.reparent(reading_position)
	colliding_obj.position = Vector3.ZERO
	colliding_obj.rotation = Vector3.ZERO
	colliding_obj.interact()
	currentReadingItem = colliding_obj


func drop(throw: bool = false) -> void:
	if main_hand.get_child_count() > 1:
		var main_hand_item = main_hand.get_child(1)
		if is_instance_of(main_hand_item, Book):
			Global.is_holding_book = false
		main_hand.remove_child(main_hand_item)
		get_parent().add_child(main_hand_item)
		main_hand_item.global_position = main_hand.global_position + (transform.basis * main_hand.position).normalized()
		main_hand_item.process_mode = Node.PROCESS_MODE_PAUSABLE
		if throw:
			var theta = camera.rotation.y
			var phi = camera.rotation.x
			var look_vec = Vector3(-sin(theta), sin(phi), -cos(theta))
			main_hand_item.linear_velocity = (transform.basis * look_vec).normalized() * THROW_SPEED

func switch_hands() -> void:
	if main_hand.get_child_count() > 1:
		var main_hand_item = main_hand.get_child(1)
		main_hand.remove_child(main_hand_item)
		if off_hand.get_child_count() > 1:
			var off_hand_item = off_hand.get_child(1)
			off_hand.remove_child(off_hand_item)
			main_hand.add_child(off_hand_item)
			off_hand_item.position = Vector3.ZERO
		off_hand.add_child(main_hand_item)
		main_hand_item.position = Vector3.ZERO
	elif off_hand.get_child_count() > 1:
		var off_hand_item = off_hand.get_child(1)
		off_hand.remove_child(off_hand_item)
		main_hand.add_child(off_hand_item)
		off_hand_item.position = Vector3.ZERO


# Signal Connections
func got_on_ladder() -> void:
	is_on_ladder = true
	climbing = true


func got_off_ladder() -> void:
	is_on_ladder = false
