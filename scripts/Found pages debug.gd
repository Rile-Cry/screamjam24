extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.OnNotesChanged.connect(OnNotesChanged)


func OnNotesChanged():
	text = "Notes found: "
	for note in Global.foundNotes:
		text += ", " + str(note.pageNumber)
