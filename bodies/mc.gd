extends CharacterBody2D
@onready var main = self.get_tree().root.get_node('main')
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var damage = 1
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


func _setup_bodyparts():
	body_parts = []
	for key in main.equipped:
		if main.equipped[key]:
			body_parts.append(key)

func _start_attacking():
	var l_arm: Node2D = $l_arm
	var r_arm: Node2D = $r_arm
	l_arm = l_arm.get_child(0)
	r_arm = r_arm.get_child(0)
	if r_arm:
		r_attack_timer.start(r_arm.attack_speed)
	if l_arm:
		l_attack_timer.start(l_arm.attack_speed)




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
		var selected_node = parent_node.get_node("img")
		if selected_node:
			selected_node.queue_free()
			parent_node.remove_child(selected_node)
			

func _remove_equipment(button_node:Button):
	var node_name = button_node.name
	var node = self.get_node(str(node_name))
	var childrens = node.get_children()
	for children in childrens:
		children.queue_free()

func _on_attack_range_body_entered(body: Node2D) -> void:
	body._take_damage(damage)

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
	var is_critical = is_critical_hit(l_arm.critical_chance)
	var d = l_arm.attack(is_critical)
	main.enemy._take_damage(d)


func is_critical_hit(critical_chance) -> bool:
	var chance = critical_chance / 100.0
	var random_value = randi() / 4294967295.0
	return random_value < chance

func _on_r_attack_timer_timeout() -> void:
	var r_arm: Node2D = $r_arm
	r_arm = r_arm.get_child(0)
	var is_critical = is_critical_hit(r_arm.critical_chance)
	var d = r_arm.attack(is_critical)
	main.enemy._take_damage(d)

	
	
