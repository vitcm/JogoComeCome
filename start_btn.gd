extends Button

func _on_mouse_entered():
	self.set_default_cursor_shape(CURSOR_POINTING_HAND)

func _on_mouse_exited():
	self.set_default_cursor_shape(CURSOR_ARROW) 
