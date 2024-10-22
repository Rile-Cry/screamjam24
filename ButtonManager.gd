extends Node


const SKAVENZOEXY_REGULAR_WY_774 = preload("res://visuals/fonts/SkavenzoexyRegular-Wy774.ttf")

var playback:AudioStreamPlaybackPolyphonic

@export var clickSound: AudioStream
@export var hoverSound: AudioStream
@export var unreadableFont: FontFile
@export var readableFont: FontFile

func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	player.volume_db = 5
	player.bus = "SoundEffects"
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.add_theme_font_override("font",unreadableFont)
		node.mouse_entered.connect(_play_hover.bind(node))
		node.mouse_exited.connect(mouseExit.bind(node))
		node.pressed.connect(_play_pressed)


func _play_hover(button: Button) -> void:
	if button.disabled: return
	playback.play_stream(hoverSound)
	button.add_theme_font_override("font",readableFont)

func mouseExit(button: Button) -> void:
	button.add_theme_font_override("font",unreadableFont)

func _play_pressed() -> void:
	playback.play_stream(clickSound)
