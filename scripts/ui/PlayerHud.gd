extends CanvasLayer

# Basic Hud :: Will definitely not look like this later, just doing interaction stuffs

var label : Label

func _ready():
	label = $Label

func _process(delta):
	label.text = Global.item_name
