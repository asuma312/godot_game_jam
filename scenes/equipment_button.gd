extends Button

var item
@onready var main = self.get_tree().root.get_node('main')
@onready var parent = main.get_node("equipment_phase")
func _on_mouse_entered() -> void:
	if parent.current_equip:
		return
	Popups.ItemPopUp(Rect2i(Vector2i(global_position), Vector2i(size) ), item)

func _on_mouse_exited() -> void:
	Popups.HidemItemPopUp()
