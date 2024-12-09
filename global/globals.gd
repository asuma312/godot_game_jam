extends Node
func _dup_obj(obj):
	print(obj)
	var f_path = obj.scene_file_path
	obj = load(f_path).instantiate()
	return obj
