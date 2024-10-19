extends Area3D


@export var collisionStrength := 20.0

@onready var knockback_sound: AudioStreamPlayer3D = %KnockbackSound


func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.apply_central_impulse(global_position.direction_to(body.global_position) * collisionStrength * body.mass)
		body.apply_torque_impulse(Vector3(0,randf_range(-2,2),0))
		knockback_sound.play()
		Camera.Instance.PlayShake(2,1)
