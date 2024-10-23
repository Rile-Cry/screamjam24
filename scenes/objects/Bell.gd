extends Interactable

@onready var bell_sound: AudioStreamPlayer = $BellSound
var gameOver := false

func interact():
	interactable = false
	super.interact()
	var moveTween := create_tween().set_trans(Tween.TRANS_SINE)
	moveTween.tween_property(self,"rotation:x",-PI/3,1)
	moveTween.tween_property(self,"rotation:x",PI/4,2)
	moveTween.tween_property(self,"rotation:x",-PI/5,2)
	moveTween.tween_property(self,"rotation:x",PI/6,2)
	moveTween.tween_property(self,"rotation:x",-PI/7,2)
	moveTween.tween_property(self,"rotation:x",0,2)
	await get_tree().create_timer(1).timeout
	bell_sound.play()

	if Demon.spawnedInstance:
		PlayerHud.Instance.display_overlay_text("The Demon Mincinos Has Been Slain")
		gameOver = true

		var vfxTween := create_tween().set_parallel(true).set_parallel(true)
		vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_density", 1.0,10.0)
		vfxTween.tween_property(Camera.Instance.environment,"volumetric_fog_albedo", Color.DIM_GRAY, 10)
		var low_pass:= AudioServer.get_bus_effect(0,3) as AudioEffectLowPassFilter
		low_pass.cutoff_hz = 2000
		AudioServer.set_bus_effect_enabled(0,5,true)
		vfxTween.tween_property(low_pass,"cutoff_hz",0,10.0)
		await vfxTween.finished
		get_tree().quit()
		return
	await get_tree().create_timer(8).timeout
	interactable = true
