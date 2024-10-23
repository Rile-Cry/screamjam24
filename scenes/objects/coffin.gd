extends Interactable

@export var nameOnCoffin := ""
@onready var here_lies_text: Label3D = %"Here lies text"
@onready var indicator: Sprite3D = %Indicator
@export var mirror: Node3D
const correctCoffin := "Andrei Dragos"
const openingTime := 10.0
var timeMouseHeld := 0.0
var isOpening := false
var openedAlready := false
@onready var distactions_sounds: AudioStreamPlayer = $DistactionsSounds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	here_lies_text.text = "Here lies " + nameOnCoffin
	if mirror:
		mirror.process_mode = Node.PROCESS_MODE_DISABLED
		mirror.visible = false

func interact():
	super.interact()
	timeMouseHeld = 0
	isOpening = true
	distactions_sounds.play()
func mouse_exited() -> void:
	stop()
	super.mouse_exited()
func _input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		stop()
func stop():
	isOpening= false
	(indicator.material_override as ShaderMaterial).set_shader_parameter("percent",0)
	distactions_sounds.stop()
func _process(delta: float) -> void:
	if !openedAlready and isOpening:
		timeMouseHeld += delta
		(indicator.material_override as ShaderMaterial).set_shader_parameter("percent",timeMouseHeld/openingTime)
		if timeMouseHeld >= openingTime:
			openedAlready = true
			interactable = false
			(indicator.material_override as ShaderMaterial).set_shader_parameter("percent",0)
			distactions_sounds.stop()
			if nameOnCoffin == correctCoffin:
				mirror.process_mode = Node.PROCESS_MODE_INHERIT
				mirror.visible = true
			else:
				(get_tree().get_first_node_in_group("player") as Player).GoInsane()



