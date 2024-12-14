extends CharacterBody2D
@onready var main = self.get_tree().root.get_node('main')
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $attack_timer
var damage = 1
var body_parts:Array = ['head','l_arm','l_leg','armor','r_arm','r_leg']
@onready var animated_sprite_2d: AnimatedSprite2D = $r_arm/r_arm

signal took_damage
signal lose_part
var jab_rotation:float = 26.3
var uppercut_rotation:float = 14
var equipped = {
	"head":preload("res://obj/equipments/head/zangbeto_head.tscn").instantiate(),
	"l_arm":preload("res://obj/equipments/arm/zangbeto_arm.tscn").instantiate(),
	"l_leg":preload("res://obj/equipments/leg/zangbeto_leg.tscn").instantiate(),
	"armor":preload("res://obj/equipments/armor/zangbeto_torso.tscn").instantiate(),
	"r_arm":preload("res://obj/equipments/arm/zangbeto_arm_b.tscn").instantiate(),
	"r_leg":preload("res://obj/equipments/leg/zangbeto_leg_b.tscn").instantiate()
}

@onready var r_attack_timer: Timer = $timers/r_attack_timer
@onready var l_attack_timer: Timer = $timers/l_attack_timer


var r_arm
var l_arm
func _ready() -> void:
	self.scale = Vector2(3,3)
	_setup_bodyparts()
	
func _start_attacking():
	l_arm = $l_arm
	r_arm = $r_arm
	l_arm = l_arm.get_child(0)
	r_arm = r_arm.get_child(0)
	l_arm.get_child(0).play("default")
	r_arm.get_child(0).play("default")
	if r_arm:
		r_attack_timer.start(r_arm.attack_speed)
	if l_arm:
		l_attack_timer.start(l_arm.attack_speed)

		



func _on_attack_range_body_entered(body: Node2D) -> void:
	body._take_damage(damage)

func _take_damage(damage):
	print("took damage")
	var choose_body_part = body_parts.pick_random()
	print(choose_body_part)
	if not choose_body_part:
		return
	var body_part = equipped[choose_body_part]
	body_part.hp -= damage
	if body_part.hp <= 0:
		body_parts.erase(choose_body_part)
		lose_part.emit(choose_body_part)
		equipped.erase(choose_body_part)
		return
	took_damage.emit()



func _setup_bodyparts():
	body_parts = []
	for key in equipped:
		if equipped[key]:
			body_parts.append(key)
func is_critical_hit(critical_chance) -> bool:
	var chance = critical_chance / 100.0
	var random_value = randi() / 4294967295.0
	return random_value < chance

func _on_r_attack_timer_timeout() -> void:
	var r_arm: Node2D = $r_arm
	r_arm = r_arm.get_child(0)
	var is_critical = is_critical_hit(r_arm.critical_chance)
	var d = r_arm.attack(is_critical)
	main.mc._take_damage(d)


func _on_l_attack_timer_timeout() -> void:
	var l_arm: Node2D = $l_arm
	l_arm = l_arm.get_child(0)
	var is_critical = is_critical_hit(l_arm.critical_chance)
	var d = l_arm.attack(is_critical)
	main.mc._take_damage(d)
