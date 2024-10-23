extends AudioStreamPlayer


const MINCINOS_APPROACHES = preload("res://Audio/Music/Mincinos Approaches.mp3")
const SPOOKY_CHURCH_AMBIENCE__1_ = preload("res://Audio/Music/Spooky Church Ambience (1).mp3")
const THE_CRYPT = preload("res://Audio/Music/The Crypt.mp3")
const MAIN_MENU_THEME = preload("res://Audio/Music/Main Menu Theme.mp3")
func fade_out():
	var tween = create_tween()
	tween.tween_property(self,"volume_db",-50,4)
	await tween.finished

func fade_in():
	var tween = create_tween()
	tween.tween_property(self,"volume_db",0,1)

func change_to_main_menu_music():
	if stream == MAIN_MENU_THEME:
		return
	stream = MAIN_MENU_THEME
	play()
	fade_in()

func change_to_crypt_music():
	await fade_out()
	stream = THE_CRYPT
	play()
	fade_in()

func change_to_demon_music():
	await fade_out()
	stream = MINCINOS_APPROACHES
	play()
	fade_in()

func change_to_church_music():

	await fade_out()
	stream = SPOOKY_CHURCH_AMBIENCE__1_
	play()
	fade_in()
