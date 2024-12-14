extends Control

func ItemPopUp(slot: Rect2i,item):
	setup_values(item)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction
	var padding = 4
	if mouse_pos.x <= get_viewport_rect().size.x/2:
		correction = Vector2i(slot.size.x + padding ,0)
	else:
		correction = Vector2i(%ItemPopUp.size.x + padding,0)
	%ItemPopUp.popup(Rect2i( slot.position + correction, %ItemPopUp.size))

func HidemItemPopUp():
	%ItemPopUp.hide()


func setup_values(item):
	if not item.get("_name"):
		return
	%NAME.text = item._name
	var containers = [%ATT1, %ATT2, %ATT3,%ATT4,%ATT5]
	for i in range(containers.size()):
		var container = containers[i]
		if i < item.atts.size():
			var item_atts:Dictionary = item.atts[i]
			var label = container.get_child(0)
			var value = container.get_child(1)
			var key_name =item_atts.keys()[0]
			label.text = key_name 
			value.text = str(item_atts[key_name])
		else:
			container.get_child(0).text = ""
			container.get_child(1).text = ""
