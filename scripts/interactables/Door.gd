extends Interactable

var startingRotationOne : Vector3
var startingRotationTwo : Vector3
var openingTween: Tween
@export var openingSpeed := 2.0
@export var closeSpeed := 3.0
@export var openingRotation := PI * .9

var isOpen := false
@onready var door_open_sound: AudioStreamPlayer3D = %"Door open sound"
@onready var door_close_sound: AudioStreamPlayer3D = %"Door close sound"
@onready var door_one: StaticBody3D = $Door
@onready var door_two: StaticBody3D = $Door2

signal OnOpen

func _ready() -> void:
	super._ready()
	startingRotationOne = door_one.rotation
	startingRotationTwo = door_two.rotation

func interact():
	super.interact()
	if openingTween and openingTween.is_running():
		return
	openingTween = create_tween().set_trans(Tween.TRANS_SINE)
	openingTween.set_parallel()

	if isOpen:
		door_close_sound.play()
		openingTween.tween_property(door_one,"rotation:y",startingRotationOne.y ,closeSpeed).set_ease(Tween.EASE_IN)
		openingTween.tween_property(door_two,"rotation:y",startingRotationTwo.y ,closeSpeed).set_ease(Tween.EASE_IN)
		isOpen = false

	else:
		door_open_sound.play()
		openingTween.tween_property(door_one,"rotation:y",startingRotationOne.y + openingRotation,openingSpeed)
		openingTween.tween_property(door_two,"rotation:y",startingRotationTwo.y - openingRotation,openingSpeed)
		isOpen = true
		OnOpen.emit()
