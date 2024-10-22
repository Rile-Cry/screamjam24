extends KeyItem

var player: Player
const teleportFromPlayerDistance:= 7
const teleportFromPlayerMinDistance:= 2
@export var positionsToSpawnAt: Node3D
@onready var jump_sound: AudioStreamPlayer = %JumpSound
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D
const sanityDrainPerTeleport := 5
var jumpTriggered := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if jumpTriggered:
		return
	if !visible_on_screen_notifier_3d.is_on_screen():
		return
	var distanceToPlayer :=global_position.distance_to(player.global_position)
	if  distanceToPlayer< teleportFromPlayerDistance and distanceToPlayer> teleportFromPlayerMinDistance:
		teleportToNextPosition()
	look_at(player.global_position)
	global_rotation.x = 0
	global_rotation.z = 0
	global_rotation.y -= PI


func teleportToNextPosition():
	jump_sound.play()
	jumpTriggered = true
	interactable = false
	await get_tree().create_timer(.5).timeout
	interactable = true
	Global.sanity -= 5
	global_position = positionsToSpawnAt.get_children().pick_random().global_position
	jumpTriggered = false
