class_name Readable
extends Interactable

@export var noteResource: NoteResource
@onready var text_on_page: Label3D = %TextOnPage
@onready var date: Label3D = %Date
@onready var pickup_drop_sound: AudioStreamPlayer = $Pickup_DropSound


func _ready() -> void:
	text_on_page.text = noteResource.text
	date.text = noteResource.date
	super._ready()


func interact():
	pickup_drop_sound.play()
	super.interact()


