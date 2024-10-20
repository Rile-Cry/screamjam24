extends RayCast3D

@onready var footsteps_player: FootstepsPlayer = $".."


# 0 = dirt
#1 = wood
#2 = stone
@export var footstepSounds: Array[AudioStream]


func _physics_process(delta: float) -> void:
	if is_colliding():
		var groundType := get_collider().get_meta("GroundType",-1) as int
		if groundType != -1:
			if footsteps_player.stream != footstepSounds[groundType]:
				footsteps_player.stream = footstepSounds[groundType]
		else:
			push_error("no ground type assigned in metadata")

