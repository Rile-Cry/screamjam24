extends Node

# Item Handling
var can_see_item := false
var item_name := ""
var is_holding_book := false

var sanity := 100:
	set(x):
		sanity = x
		OnSanityChanged.emit()
signal OnSanityChanged

var foundNotes: Array[NoteResource]
signal OnNotesChanged

func AddNote(note: NoteResource):
	if foundNotes.has(note):
		return
	foundNotes.push_back(note)
	OnNotesChanged.emit()
