extends Node

# Item Handling
var can_see_item := false
var item_name := ""
var is_holding_book := false
var sanity_list : Dictionary = {}
var time := 0.

var sanity := 100:
	set(x):
		sanity = x
		if sanity < 0:
			sanity = 0
		OnSanityChanged.emit()
signal OnSanityChanged

var foundNotes: Array[NoteResource]
signal OnNotesChanged

func AddNote(note: NoteResource):
	if foundNotes.has(note):
		return
	foundNotes.push_back(note)
	OnNotesChanged.emit()

func _process(delta) -> void:
	if time > 1:
		var delta_sanity = 0
		for id in sanity_list:
			delta_sanity += sanity_list[id]
		sanity += delta_sanity
		time = 0.

	time += delta
