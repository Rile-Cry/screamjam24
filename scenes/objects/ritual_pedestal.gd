class_name RitualPedestal
extends Interactable

var is_holding_item = false

@onready var pedestal_slot := $ItemSpot
var player : Player
@onready var hover_sound: AudioStreamPlayer3D = $HoverSound
var volumeTween:Tween

func _ready():
	super._ready()
	player = get_tree().get_first_node_in_group("player")


func _process(_delta):
	if pedestal_slot.get_child_count() > 1:
		is_holding_item = true
	else:
		is_holding_item = false


func interact():
	var hand = player.get_child(2).get_child(1)
	if not is_holding_item:
		if hand.get_child_count() > 1:
			var hand_item = hand.get_child(1)
			if is_instance_of(hand_item, KeyItem):
				player.drop()
				hand_item.get_parent().remove_child(hand_item)
				pedestal_slot.add_child(hand_item)
				hand_item.process_mode = Node.PROCESS_MODE_DISABLED
				hand_item.position = Vector3.ZERO
				toggle_sound(true)
	else:
		if hand.get_child_count() == 1:
			var item = pedestal_slot.get_child(1)
			pedestal_slot.remove_child(item)
			hand.add_child(item)
			item.position = Vector3.ZERO
			toggle_sound(false)


func toggle_sound(on: bool):
	if volumeTween and volumeTween.is_running():
		volumeTween.kill()
	volumeTween = create_tween()
	if on:
		volumeTween.tween_property(hover_sound,"volume_db",0,.2)
	else:
		volumeTween.tween_property(hover_sound,"volume_db",-80,1)
