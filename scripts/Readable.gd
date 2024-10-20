class_name Readable
extends Interactable

@export var noteResource: NoteResource
@onready var text_on_page: Label3D = %TextOnPage
var isHeld := false


func _ready() -> void:
	super._ready()
	text_on_page.text = noteResource.text

func interact():
	isHeld = true


