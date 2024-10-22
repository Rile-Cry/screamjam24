class_name DemonKnockbackField
extends Area3D


@export var collisionStrength := 20.0

@onready var knockback_sound: AudioStreamPlayer3D = %KnockbackSound
@onready var demon: CharacterBody3D = $".."
var canDamagePlayer := false

func _on_body_entered(body: Node3D) -> void:
	if body is Player and canDamagePlayer:
		Global.sanity = 0
		Camera.Instance.PlayShake(5,.5)
		await  get_tree().create_timer(5).timeout
		demon.reset_ritual()
	if body is RigidBody3D:
		body.apply_central_impulse(global_position.direction_to(body.global_position) * collisionStrength * body.mass)
		body.apply_torque_impulse(Vector3(0,randf_range(-2,2),0))
		knockback_sound.play()
		Camera.Instance.PlayShake(2,1)
