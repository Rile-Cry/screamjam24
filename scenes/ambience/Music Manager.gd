extends AudioStreamPlayer


const MINCINOS_APPROACHES = preload("res://Audio/Music/Mincinos Approaches.mp3")
const SPOOKY_CHURCH_AMBIENCE__1_ = preload("res://Audio/Music/Spooky Church Ambience (1).mp3")

func change_to_demon_music():
	stream = MINCINOS_APPROACHES
	play()

func change_to_non_demon_music():
	stream = SPOOKY_CHURCH_AMBIENCE__1_
	play()
