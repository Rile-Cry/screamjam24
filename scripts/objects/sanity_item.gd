class_name SanityItem
extends RigidBody3D

const DRAIN_STRENGTH := -1

var is_player_around := false
var time := 0.0

@onready var area := $Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", player_check_enter)
	area.connect("body_exited", player_check_leave)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sanity_drain()


func sanity_drain() -> void:
	if Global.time > 1:
		if is_player_around:
			Global.sanity_list[get_instance_id()] = DRAIN_STRENGTH
		else:
			Global.sanity_list.erase(get_instance_id())


func player_check_enter(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_around = true


func player_check_leave(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_around = false
