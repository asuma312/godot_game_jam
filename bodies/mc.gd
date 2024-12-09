extends CharacterBody2D
@onready var main = self.get_tree().root.get_node('main')
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $attack_timer
var damage = 1
var body_parts:Array
@onready var collision_shape_2d: CollisionShape2D = $attack_range/CollisionShape2D

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
		var selected_node:Sprite2D = parent_node.get_node("img")
		if selected_node:
			selected_node.queue_free()
			parent_node.remove_child(selected_node)
			

func _remove_equipment(button_node:Button):
	var node_name = button_node.name
	var node = self.get_node(str(node_name))
	var childrens = node.get_children()
	for children in childrens:
		children.queue_free()
		
func _attack() ->void:
	animation_player.play("upper_attack")


func _on_attack_timer_timeout() -> void:
	_attack()


func _on_attack_range_body_entered(body: Node2D) -> void:
	body._take_damage(damage)

func _take_damage(damage):
	var choose_body_part = body_parts.pick_random()
	var body_part = main.equipped[choose_body_part]
	body_part.hp -= damage
	if body_part.hp <= 0:
		lose_part.emit(body_part.get_parent())
		return
	took_damage.emit()
