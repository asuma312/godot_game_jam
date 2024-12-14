extends CharacterBody2D
@onready var main = self.get_tree().root.get_node('main')
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var body_parts:Array
@onready var collision_shape_2d: CollisionShape2D = $attack_range/CollisionShape2D
@onready var r_attack_timer: Timer = $timers/r_attack_timer
@onready var l_attack_timer: Timer = $timers/l_attack_timer

signal took_damage
signal lose_part

func _ready() -> void:
	_setup_equipments()
	_setup_bodyparts()
	collision_shape_2d.disabled = true
var plus_damage_array = []
var plus_crit_array = []
var plus_as_array = []

func _setup_bodyparts():
	body_parts = []
	for key in main.equipped:
		if main.equipped[key]:
			body_parts.append(key)
			var equip = main.equipped[key]
			if equip.type in ['l_arm','r_arm']:
				return
			if not equip.get("atts"):
				continue
			var equip_atributes = equip.atts
			for _dict in equip_atributes:
				var _key = _dict.keys()[0]
				if _key == 'Damage':
					plus_damage_array.append(equip_atributes[_key])
				if _key == "Attack speed":
					plus_as_array.append(equip_atributes[_key])
				if _key == 'Critical chance':
					plus_crit_array.append(equip_atributes[_key])

func generate_random_number() -> float:
	var min_value: float = 0.5
	var max_value: float = 1

	var random_number: float = randf_range(min_value, max_value)
	return random_number

func _start_attacking():
	var l_arm: Node2D = $l_arm
	var r_arm: Node2D = $r_arm
	l_arm = l_arm.get_child(0)
	r_arm = r_arm.get_child(0)
	if r_arm:
		var temp_r_arm_atk_speed = r_arm.attack_speed - sum_array_with_reduce(plus_as_array)
		r_attack_timer.start(temp_r_arm_atk_speed)
	if l_arm:
		var temp_l_arm_atk_speed = l_arm.attack_speed - sum_array_with_reduce(plus_as_array)
		l_attack_timer.start(temp_l_arm_atk_speed + generate_random_number())




func _setup_equipments():
	for key in main.equipped:
		var selected_equip:Node2D = main.equipped[key]
		if not selected_equip:
			continue
		var selected_node:Node2D = get_node(key)
		selected_node.add_child(Globals._dup_obj(selected_equip))

func _reset_equipments():
	for key in main.equipped:
		var parent_node:Node2D = get_node(key)
		for selected_node in parent_node.get_children():
			if selected_node:
				selected_node.queue_free()
				parent_node.remove_child(selected_node)
			

func _remove_equipment(button_node:Button):
	var node_name = button_node.name
	var node = self.get_node(str(node_name))
	var childrens = node.get_children()
	for children in childrens:
		children.queue_free()

func _take_damage(damage):
	await _setup_bodyparts()
	var choose_body_part = body_parts.pick_random()
	var body_part = main.equipped[choose_body_part]
	body_part.hp -= damage
	if body_part.hp <= 0:
		lose_part.emit(body_part.get_parent())
		return
	took_damage.emit()


func _on_l_attack_timer_timeout() -> void:
	var l_arm: Node2D = $l_arm
	l_arm = l_arm.get_child(0)
	if not l_arm:
		return
	var is_critical = is_critical_hit(l_arm.critical_chance)
	var d = l_arm.attack(is_critical)
	d += sum_array_with_reduce(plus_damage_array)
	main.enemy._take_damage(d)

func sum_array_with_reduce(array: Array) -> int:
	var total = 0
	for number in array:
		total += number
	return total
func is_critical_hit(critical_chance) -> bool:
	var temp_critical_chance = critical_chance + sum_array_with_reduce(plus_crit_array)
	var chance = temp_critical_chance / 100.0
	var random_value = randi() / 4294967295.0
	return random_value < chance

func _on_r_attack_timer_timeout() -> void:
	var r_arm: Node2D = $r_arm
	r_arm = r_arm.get_child(0)
	if not r_arm:
		return
	var is_critical = is_critical_hit(r_arm.critical_chance)
	var d = r_arm.attack(is_critical)
	d += sum_array_with_reduce(plus_damage_array)
	main.enemy._take_damage(d)

	
	
