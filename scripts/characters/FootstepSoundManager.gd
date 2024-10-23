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
	else:
		if footsteps_player.stream != footstepSounds[2]:
				footsteps_player.stream = footstepSounds[2]
