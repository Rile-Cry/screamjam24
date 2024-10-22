extends Interactable

var player: Player
@onready var cutting_sound: AudioStreamPlayer = %"Cutting sound"
@onready var success_sound: AudioStreamPlayer = %SuccessSound
@onready var success_shake: ShakerComponent3D = $SuccessShake
@onready var success_sound_2: AudioStreamPlayer = %SuccessSound2
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var fail_sound: AudioStreamPlayer = %FailSound

var filled := false
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func interact():
	if filled:
		return
	super.interact()
	for child in player.main_hand.get_children():
		if child is Interactable:
			var knife_name = child.itemName
			if knife_name.contains("Knife"):
				player.animation_player.play("CutSelfAnimation")
				cutting_sound.play()
				filled = true
				await player.animation_player.animation_finished
				await get_tree().create_timer(1).timeout
				if knife_name == "Jack's Knife":
					playerHasKnife()
				else:
					Global.sanity =0
			return

	var jumpTween := create_tween()
	jumpTween.tween_property(self,"global_position:y", global_position.y + .2,.1)
	fail_sound.play()
	interactable = false
	await jumpTween.finished
	await get_tree().create_timer(.2).timeout
	interactable = true

func playerHasKnife():
	itemName = "Full Chalice"
	success_sound.play()
	success_sound_2.play()
	success_shake.play_shake()
	omni_light_3d.visible = true
	var startingDensity := Camera.Instance.environment.volumetric_fog_density
	var vfxTween := create_tween().set_parallel(true)
	vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_density", 1.0,8.40)
	vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_albedo", Color.DARK_BLUE, 8)
	vfxTween.tween_property(omni_light_3d,"light_energy", 1.0, 8)
	await vfxTween.finished
	vfxTween = create_tween().set_parallel(true)
	vfxTween.tween_property(omni_light_3d,"light_energy", 0, 4)
	vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_density", startingDensity,4.40)
	vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_albedo", Color.WHITE, 4)
	type = ItemType.PICKUP
	await vfxTween.finished
	omni_light_3d.visible = false
	interactDescription = "Pickup"


func mouse_entered():
	var isholdingKnife := false
	for child in player.main_hand.get_children():
		if child is Interactable:
			if child.itemName.contains("Knife"):
				isholdingKnife = true
	if isholdingKnife:
		interactDescription = "Fill with Blood"
	else:
		interactDescription = "Demands Blood"
	super.mouse_entered()
