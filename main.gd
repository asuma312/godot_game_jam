extends Node2D

var equipments = [
	preload("res://obj/equipments/arm/l_white.tscn").instantiate(),
	preload("res://obj/equipments/arm/r_white.tscn").instantiate(),
	preload("res://obj/equipments/armor/white.tscn").instantiate(),
	preload("res://obj/equipments/head/white.tscn").instantiate(),
	preload("res://obj/equipments/leg/l_white.tscn").instantiate(),
	preload("res://obj/equipments/leg/r_white.tscn").instantiate(),
	]
const EQUIPMENT_PHASE = preload("res://scenes/equipment_phase.tscn")
const BATTLE_PHASE = preload("res://scenes/battle_phase.tscn")
var equipped = {
	"head":null,
	"l_arm":null,
	"l_leg":null,
	"armor":null,
	"r_arm":null,
	"r_leg":null
}

var mc

var bosses = ["first boss"]

func _start_battle(boss_index):
	var real_boss_index = int(boss_index) - 1
	var chosen_boss = bosses[real_boss_index]
	var temp_scene = BATTLE_PHASE.instantiate()
	temp_scene._set_mc(mc)
	_start_new_scene(temp_scene)


func _start_new_scene(scene):
	for children in self.get_children():
		self.remove_child(children)
	self.add_child(scene)
	
