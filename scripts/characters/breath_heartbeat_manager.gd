extends Node3D

@onready var breath: AudioStreamPlayer = %Breath
@onready var heartbeat: AudioStreamPlayer = %Heartbeat
@onready var heartbeat_timer: Timer = %HeartbeatTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.OnSanityChanged.connect(OnSantiyChanged)
	OnSantiyChanged()


func OnSantiyChanged():
	var sanityPercent := clamp(1 - (Global.sanity/100.0),0,1)  as float
	heartbeat_timer.wait_time = lerp(2.0,.6, sanityPercent)
	heartbeat.volume_db = lerp(-35.,5., sanityPercent)

	breath.volume_db = lerp(-30.,5., sanityPercent)
