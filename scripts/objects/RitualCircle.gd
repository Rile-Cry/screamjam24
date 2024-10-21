extends Node3D

var pedestal_list : Array[RitualPedestal]
var summoned := false

@onready var demon : PackedScene = preload("res://scenes/characters/demon.tscn")
@onready var demon_spawn := $DemonSpawn

func _ready() -> void:
	grab_pedestals()


func _process(delta) -> void:
	if Global.time > 1 and not summoned:
		if check_pedestals():
			var demon_instance = demon.instantiate()
			get_tree().root.add_child(demon_instance)
			demon_instance.position = demon_spawn.global_position
			summoned = true


func check_pedestals() -> bool:
	var check := true
	for pedestal in pedestal_list:
		check = check and pedestal.is_holding_item
	return check


func grab_pedestals() -> void:
	for child in get_children():
		if is_instance_of(child, RitualPedestal):
			pedestal_list.append(child)
