extends Area3D

@export var teleport_spot: Node3D



func _on_body_entered(body: Node3D) -> void:
	if Demon.spawnedInstance and body is Player:
		Demon.spawnedInstance.global_position = teleport_spot.global_position
