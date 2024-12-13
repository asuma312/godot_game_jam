extends PanelContainer



func _on_mouse_entered() -> void:
	Popups.ItemPopUp(Rect2i(Vector2i(global_position), Vector2i(size) ), null)


func _on_mouse_exited() -> void:
	Popups.HidemItemPopUp()
