extends Node2D
@onready var p_stats: VBoxContainer = $PLAYERSTATS_MENU/p_stats
@onready var main = get_parent()

var mc:CharacterBody2D
var enemy

func _ready() -> void:
	first_setup()
	_setup_units()
	_start_attacking()
func _set_mc(_mc_):
	mc = _mc_

func _process(delta: float) -> void:
	_update_life_node()
	
func first_setup():
	for children in p_stats.get_children():
		var equipment = main.equipped.get(children.name)
		if not equipment:
			continue
		var new_equipment = Globals._dup_obj(equipment)
		var img_node = children.get_node("img")
		img_node.add_child(new_equipment)
		
		var img_size = img_node.get_rect().size
		var equip_size = new_equipment.get_rect().size if new_equipment is Control else Vector2.ZERO
		new_equipment.position = Vector2(
			(img_size.x - equip_size.x) / 2,
			(img_size.y - equip_size.y) / 2
		)
		
		var life_node:ProgressBar = children.get_node("life")
		life_node.max_value = equipment.hp
		life_node.value = equipment.hp

func _update_life_node():
	for children in p_stats.get_children():
		var life_node:ProgressBar = children.get_node("life")
		var equipment = main.equipped.get(children.name)
		if not equipment:
			continue
		life_node.value = equipment.hp

func _setup_units():
	var mc_pos: Node2D = $BATTLE_MENU/MC_POS
	mc_pos.add_child(Globals._dup_obj(mc))
	var enemy_pos: Node2D = $BATTLE_MENU/ENEMY_POS
	enemy = Globals._dup_obj(mc)

	enemy_pos.add_child(enemy)
	for child in enemy.get_children():
		if child is Node2D:
			var sprite = child.get_node("img")
			if sprite is Sprite2D:
				sprite.flip_h = true


func _start_attacking():
	enemy.attack_timer.start()
	mc.attack_timer.start()
	mc.connect('took_damage',_update_life_node)
	enemy.connect('took_damage',_update_life_node)
