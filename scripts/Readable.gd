class_name Readable
extends Interactable

@export var noteResource: NoteResource
@onready var text_on_page: Label3D = %TextOnPage
var isHeld := false
@onready var date: Label3D = %Date


func _ready() -> void:
	text_on_page.text = noteResource.text
	date.text = noteResource.date
	super._ready()


func interact():
	isHeld = true


