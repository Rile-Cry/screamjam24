extends StaticBody3D

@onready var area := $Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", body_entered)
	area.connect("body_exited", body_exited)

func body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.got_on_ladder()

func body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.got_off_ladder()
