extends Interactable

var startingRotation: Vector3
var openingTween: Tween
@export var openingSpeed := 2.0
@export var closeSpeed := 3.0
@export var openingRotation := PI * .9

var isOpen := false
@onready var door_open_sound: AudioStreamPlayer3D = %"Door open sound"
@onready var door_close_sound: AudioStreamPlayer3D = %"Door close sound"

signal OnOpen

func _ready() -> void:
	super._ready()
	startingRotation = rotation

func interact():
	super.interact()
	if openingTween and openingTween.is_running():
		return
	openingTween = create_tween().set_trans(Tween.TRANS_SINE)

	if isOpen:
		door_close_sound.play()
		openingTween.tween_property(self,"rotation:y",startingRotation.y ,closeSpeed).set_ease(Tween.EASE_IN)
		isOpen = false

	else:
		door_open_sound.play()
		openingTween.tween_property(self,"rotation:y",startingRotation.y + openingRotation,openingSpeed)
		isOpen = true
		OnOpen.emit()
