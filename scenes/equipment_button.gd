extends Button

var item

func _on_mouse_entered() -> void:
	Popups.ItemPopUp(Rect2i(Vector2i(global_position), Vector2i(size) ), item)

func _on_mouse_exited() -> void:
	Popups.HidemItemPopUp()
