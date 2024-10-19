extends CanvasLayer

# Basic Hud :: Will definitely not look like this later, just doing interaction stuffs

@onready var label := $Label

func _process(delta) -> void:
	label.text = Global.item_name
