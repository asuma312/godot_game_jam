extends Node2D
@onready var p_stats: VBoxContainer = $PLAYERSTATS_MENU/p_stats
@onready var e_stats: HBoxContainer = $ENEMYSTATS_MENU/e_stats
@onready var battle_menu: Panel = $BATTLE_MENU

@onready var main = get_parent()

var mc:CharacterBody2D
var enemy

func _ready() -> void:
	_setup_units()
	first_player_stats_setup()
	first_enemy_stats_setup()
	_start_attacking()
func _set_mc(_mc_):
	mc = _mc_
	

func first_player_stats_setup():
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

func first_enemy_stats_setup():
	for children in e_stats.get_children():
		var equipment = enemy.equipped.get(children.name)
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

func _update_player_life_node():
	for children in p_stats.get_children():
		var life_node:ProgressBar = children.get_node("life")
		var equipment = main.equipped.get(children.name)
		if not equipment:
			continue
		life_node.value = equipment.hp


func _update_enemy_life_node():
	for children in e_stats.get_children():
		var life_node:ProgressBar = children.get_node("life")
		var equipment = enemy.equipped.get(children.name)
		if not equipment:
			continue
		life_node.value = equipment.hp

func _verify_body_parts():
	for b in main.equipped:
		if main.equipped[b]:
			return true
	return false

		
func _on_p_body_part_loss(body_part):
	_update_player_life_node()
	var p_stats_node = p_stats.get_node(str(body_part.name)+"/img")
	p_stats_node.queue_free()
	var battle_menu_node = battle_menu.get_node("MC_POS/mc/"+str(body_part.name)+"/img")
	battle_menu_node.queue_free()
	main.equipped[str(body_part.name)].queue_free()
	main.equipped[str(body_part.name)] = null
	mc._setup_bodyparts()
	if not _verify_body_parts():
		return _on_lose_fight()

		
func _setup_units():
	var mc_pos: Node2D = $BATTLE_MENU/MC_POS
	mc = Globals._dup_obj(mc)
	mc_pos.add_child(mc)
	var enemy_pos: Node2D = $BATTLE_MENU/ENEMY_POS
	print(enemy)
	enemy = Globals._dup_obj(enemy)

	enemy_pos.add_child(enemy)

func _on_lose_fight():
	main._start_equipment()

func _start_attacking():
	mc.connect('took_damage',_update_player_life_node)
	enemy.connect('took_damage',_update_enemy_life_node)
	mc.connect('lose_part',_on_p_body_part_loss)
	mc.connect('no_body_parts',_on_lose_fight)
	enemy.attack_timer.start()
	mc.attack_timer.start()
