class_name PlayerHud
extends CanvasLayer

# Basic Hud :: Will definitely not look like this later, just doing interaction stuffs

@onready var book_label := $BookLabel
@onready var label := $HoverText/Label
@onready var sanity_label := $Sanity/Label
@onready var interactHelperLabel: Label = $InteractHelper/Label
@onready var hand_swap_label: Label = $HandSwapIndicator/HandSwapLabel
@onready var overlay_text: Label = $OverlayText/OverlayText
@onready var hint_label := $Hint/Label
var overlayTween: Tween
const overlayDisplayTime := 5.0
@onready var drop_note_text: Label = $DropNoteText/DropNoteText
static var Instance: PlayerHud


var player: Player:
	get:
		if !player:
			player =get_tree().get_first_node_in_group("player")
		return player


func _ready() -> void:
	add_to_group("hud")
	process_mode = Node.PROCESS_MODE_ALWAYS
	Instance = self


func _process(delta) -> void:
	if Global.hoveredItem:
		label.text = Global.hoveredItem.itemName
		if Global.hoveredItem.interactable:
			interactHelperLabel.text = Global.hoveredItem.interactDescription + " (E)"
		else:
			interactHelperLabel.text = ""
	else:
		label.text = ""
		interactHelperLabel.text = ""

	if player.main_hand.get_child_count() >1 or player.off_hand.get_child_count() >1:
		hand_swap_label.text = "Tab to Swap Hands\n'Q' to Drop"
	else:
		hand_swap_label.text = ""

	if player.currentReadingItem:
		interactHelperLabel.text = "Press 'E' to Drop Note"
	
	if Global.access_hint:
		hint_label.text = Global.get_hint()
	else:
		hint_label.text = ""


func display_overlay_text(text: String):
	if overlayTween:
		overlayTween.kill()
	overlay_text.modulate.a = 0
	overlay_text.text = text
	overlayTween = create_tween()
	overlayTween.tween_property(overlay_text,"modulate:a",1,1)
	await get_tree().create_timer(overlayDisplayTime).timeout
	overlayTween = create_tween()
	overlayTween.tween_property(overlay_text,"modulate:a",0,1)
