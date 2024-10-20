extends RayCast3D

@onready var footsteps_player: FootstepsPlayer = $".."

@onready var player: Player = $"../.."

# 0 = dirt
#1 = wood
#2 = stone
#3 = ladder
@export var footstepSounds: Array[AudioStream]



func _physics_process(delta: float) -> void:
	if player.is_on_ladder:
		if footsteps_player.stream != footstepSounds[3]:
				footsteps_player.stream = footstepSounds[3]
		return
	if is_colliding():
		var groundType := get_collider().get_meta("GroundType",-1) as int
		if groundType != -1:
			if footsteps_player.stream != footstepSounds[groundType]:
				footsteps_player.stream = footstepSounds[groundType]
		else:
			push_error("no ground type assigned in metadata")

