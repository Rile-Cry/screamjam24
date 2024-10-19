extends AudioStreamPlayer3D

var parentRigidbody: RigidBody3D
var timeLastSoundPlayedAt : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent := get_parent()
	if parent is RigidBody3D:
		parentRigidbody = parent
		parentRigidbody.body_entered.connect(OnCollisionEnter)
		parentRigidbody.contact_monitor = true
		parentRigidbody.max_contacts_reported = 3

func OnCollisionEnter(other: Node):
	if Time.get_ticks_msec() - timeLastSoundPlayedAt <1000.0 or parentRigidbody.linear_velocity.length() <0.5:
		return
	timeLastSoundPlayedAt = Time.get_ticks_msec()
	volume_db = lerp(-20,0,clamp(parentRigidbody.linear_velocity.length() /5,0,1))
	play()

