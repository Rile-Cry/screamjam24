extends Node

# Item Handling
var can_see_item := false
var hoveredItem : Interactable
var is_holding_book := true
var sanity_list : Dictionary = {}
var time := 0.

# Checkpoints
var checkpoints := {
	"lit_candles" = false,
	"picked_up_candle" = false,
	"picked_up_doll" = false,
	"picked_up_knife" = false,
	"picked_up_chalice" = false,
	"picked_up_book" = false,
	"found_mirror" = false,
	"summoned_demon" = false,
}
var hints := {
	"lit_candles" = "You should try lighting the nearby candles...",
	"picked_up_candle" = "You've found a key item, you should pick it up and gather the others...",
	"picked_up_doll" = "There seems to be something watching you, maybe not looking at it will help...",
	"picked_up_knife" = "The office seems to hold a set of knives and there's a chalice as well . . .",
	"picked_up_chalice" = "You've found the correct knife! It's a key item, now should fill the chalice with something . . .",
	"picked_up_book" = "There's a book somewhere that when dropped somewhere in the office, may lead elsewhere. . .",
	"found_mirror" = "One of these graves may contain the final key item. . .",
	"summoned_demon" = "That weird room in the crypt has as many pedestals as key items . . . I wonder."
}

# Accessibility Options
var access_hint := false

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

func get_hint() -> String:
	for key in checkpoints:
		if checkpoints[key]:
			continue
		else:
			return hints[key]
	return "Run to the belltower and ring the bell!!!"
	
