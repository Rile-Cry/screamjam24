class_name Interactable
extends CollisionObject3D

# Type enum for interaction, will flesh out later
enum ItemType {
	READABLE,
	PICKUP,
	INTERACT,
}

# Variables
@onready var OutlineShader = preload("res://visuals/shaders/base_mat.tres")
@onready var mesh := $MeshInstance3D
var can_pickup : bool = true

# Export Variables
@export var type : ItemType = ItemType.INTERACT

# Signals

signal OnInteracted

func _ready():
	pass

#override in inherited class
func interact():
	OnInteracted.emit()
	return

# Handle raycasting from player
func mouse_entered():
	Global.item_name = name
	if type == ItemType.PICKUP:
		can_pickup = true
		if mesh:
			mesh.set_surface_override_material(0, OutlineShader)

func mouse_exited():
	Global.item_name = ""
	can_pickup = false
	if mesh:
		mesh.set_surface_override_material(0, null)
