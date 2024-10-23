extends TextureRect

# just to make pillars center on screen
const x_offset := 40

func _process(delta: float) -> void:
	position = get_global_mouse_position()/25 - size/2 + get_viewport_rect().size/2 + Vector2(x_offset,0)
