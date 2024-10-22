extends KeyItem

var player: Player
const teleportFromPlayerDistance:= 5
const teleportFromPlayerMinDistance:= 2
@export var positionsToSpawnAt: Node3D
@onready var jump_sound: AudioStreamPlayer = %JumpSound
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D
const sanityDrainPerTeleport := 5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if !visible_on_screen_notifier_3d.is_on_screen():
		return
	var distanceToPlayer :=global_position.distance_to(player.global_position)
	if  distanceToPlayer< teleportFromPlayerDistance and distanceToPlayer> teleportFromPlayerMinDistance:
		teleportToNextPosition()


func teleportToNextPosition():
	Global.sanity -= 5
	jump_sound.play()

	global_position = positionsToSpawnAt.get_children().pick_random().global_position
