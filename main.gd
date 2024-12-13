extends Node2D

var equipments = [
	preload("res://obj/equipments/arm/l_base.tscn").instantiate(),
	preload("res://obj/equipments/arm/r_base.tscn").instantiate(),
	preload("res://obj/equipments/armor/base.tscn").instantiate(),
	preload("res://obj/equipments/head/base.tscn").instantiate(),
	preload("res://obj/equipments/leg/l_base.tscn").instantiate(),
	preload("res://obj/equipments/leg/r_base.tscn").instantiate(),
	preload("res://obj/equipments/leg/zangbeto_leg_b.tscn").instantiate(),
		preload("res://obj/equipments/arm/zangbeto_arm.tscn").instantiate(),
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
var scenes = {
	
}
var mc
var enemy
var bosses = [preload("res://bodies/boss_1.tscn"),preload("res://bodies/boss_2.tscn")]

func _start_battle(boss_index):
	var real_boss_index = int(boss_index) - 1
	var chosen_boss = bosses[real_boss_index].instantiate()
	var temp_scene = BATTLE_PHASE.instantiate()
	temp_scene._set_mc(mc)
	temp_scene.enemy = chosen_boss
	scenes['start_equipment'] = get_node("equipment_phase")
	enemy = chosen_boss
	_start_new_scene(temp_scene)

func _reset_battle_phase():
	var _battle_node = self.get_node("battle_phase")
	if _battle_node:
		_battle_node.queue_free()

func _start_equipment():
	_reset_battle_phase()
	
	var temp_scene = EQUIPMENT_PHASE.instantiate()
	var scene = scenes.get("start_equipment")
	if scene:
		scene._setup_equips_menu()
		_start_new_scene(scene)
		mc._reset_equipments()
		mc._setup_equipments()
		return
	_start_new_scene(temp_scene)


func _start_new_scene(scene):
	for children in self.get_children():
		self.remove_child(children)
	self.add_child(scene)
	
