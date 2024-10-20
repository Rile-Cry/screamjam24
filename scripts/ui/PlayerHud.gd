extends CanvasLayer

# Basic Hud :: Will definitely not look like this later, just doing interaction stuffs

@onready var book_label := $BookLabel
@onready var label := $HoverText/Label
@onready var sanity_label := $Sanity/Label

func _ready() -> void:
	add_to_group("hud")
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event) -> void:
	if Global.is_holding_book and event.is_action_pressed("read"):
		if get_tree().paused:
			close_book()
		else:
			open_book()

func _process(delta) -> void:
	label.text = Global.item_name
	sanity_label.text = str(Global.sanity)

func open_book() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	book_label.show()

func close_book() -> void:
	book_label.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
