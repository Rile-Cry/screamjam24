extends CanvasLayer

@onready var chromatic_aberation: ColorRect = $ChromaticAberation

func _ready() -> void:
	Global.connect("OnSanityChanged", raise_chromatic)
	chromatic_aberation.color.a = 0.

func raise_chromatic() -> void:
	if Global.sanity <= 75:
		chromatic_aberation.color.a = (75. - Global.sanity) / 75.
	else:
		chromatic_aberation.color.a = 0.


