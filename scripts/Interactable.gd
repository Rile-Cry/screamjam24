extends CollisionObject3D

# Type enum for interaction, will flesh out later
enum ItemType {
	READABLE,
	PICKUP,
	INTERACT
}

# Variables
var can_pickup : bool = true

# Export Variables
@export var type : ItemType = ItemType.INTERACT

# Handle raycasting from player
func mouse_entered():
	Global.item_name = name
	if type == ItemType.PICKUP:
		can_pickup = true

func mouse_exited():
	Global.item_name = ""
	can_pickup = false
