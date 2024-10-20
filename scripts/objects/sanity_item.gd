class_name SanityItem
extends RigidBody3D

const DRAIN_STRENGTH := 1

var is_player_around := false
var time := 0.0

@onready var area := $Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", player_check_enter)
	area.connect("body_exited", player_check_leave)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sanity_drain(delta)


func sanity_drain(delta) -> void:
	if time > 1:
		if is_player_around:
			Global.sanity -= DRAIN_STRENGTH
		time = 0.0
	
	time += delta


func player_check_enter(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_around = true


func player_check_leave(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_around = false
