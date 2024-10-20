class_name Interactable
extends CollisionObject3D

# Type enum for interaction, will flesh out later
enum ItemType {
	READABLE,
	PICKUP,
	INTERACT,
}

# Variables
@onready var OutlineShader = preload("res://visuals/materials/outline_mat.tres")
@onready var mesh_list : Array[MeshInstance3D] = []
var can_pickup : bool = true

# Export Variables
@export var type : ItemType = ItemType.INTERACT

# Signals

signal OnInteracted

func _ready():
	grab_meshes()


#override in inherited class
func interact():
	OnInteracted.emit()
	return


# Handle raycasting from player
func mouse_entered():
	Global.item_name = name
	if type == ItemType.PICKUP:
		can_pickup = true
		if mesh_list.size() > 0:
			for mesh in mesh_list:
				if mesh.get_surface_override_material(0) != null :
					if mesh.get_surface_override_material(0) != OutlineShader:
						mesh.get_surface_override_material(0).next_pass = OutlineShader
				else:
					mesh.set_surface_override_material(0, OutlineShader)
		#if mesh:
			#mesh.set_surface_override_material(0, OutlineShader)


func mouse_exited():
	Global.item_name = ""
	can_pickup = false
	if mesh_list.size() > 0:
		for mesh in mesh_list:
			if mesh.get_surface_override_material(0) == OutlineShader:
				mesh.set_surface_override_material(0, null)
			elif mesh.get_surface_override_material(0) != null:
				mesh.get_surface_override_material(0).next_pass = null
	#if mesh:
		#mesh.set_surface_override_material(0, null)

func grab_meshes(parent = self) -> void:
	var children = parent.get_children()
	for child in children:
		if is_instance_of(child, MeshInstance3D):
			mesh_list.append(child)

		if child.get_child_count() > 0:
			grab_meshes(child)
