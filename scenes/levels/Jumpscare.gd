extends Sprite3D

var isSeen := false
@onready var player: Player = %Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSeen:
		var x = global_position.y
		global_position = global_position.move_toward(player.global_position, delta * 20 )
		global_position.y = x
		if global_position.distance_to(player.global_position) <1:
			queue_free()



func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	isSeen = true
