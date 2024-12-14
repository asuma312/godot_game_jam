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
	"head":preload("res://obj/equipments/head/protoeva_head.tscn").instantiate(),
	"l_arm":preload("res://obj/equipments/arm/l_protoeva.tscn").instantiate(),
	"l_leg":preload("res://obj/equipments/leg/l_protoeva.tscn").instantiate(),
	"armor":preload("res://obj/equipments/armor/protoeva.tscn").instantiate(),
	"r_arm":preload("res://obj/equipments/arm/r_protoeva.tscn").instantiate(),
	"r_leg":preload("res://obj/equipments/leg/r_protoeva.tscn").instantiate()
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
	l_arm.play("default")
	r_arm.play("default")
	var temp_r_arm_atk_speed = r_arm.attack_speed - sum_array_with_reduce(plus_as_array)
	var temp_l_arm_atk_speed = l_arm.attack_speed - sum_array_with_reduce(plus_as_array)
	if r_arm:
		r_attack_timer.start(temp_r_arm_atk_speed)
	if l_arm:
		l_attack_timer.start(temp_l_arm_atk_speed + generate_random_number())
		

func generate_random_number() -> float:
	var min_value: float = 0.5
	var max_value: float = 1

	var random_number: float = randf_range(min_value, max_value)
	return random_number

func _on_attack_range_body_entered(body: Node2D) -> void:
	body._take_damage(damage)

func _take_damage(damage):
	var choose_body_part = body_parts.pick_random()
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

var plus_damage_array = []
var plus_as_array = []
var plus_crit_array = []
func _setup_bodyparts():
	body_parts = []
	for key in equipped:
		if equipped[key]:
			body_parts.append(key)
			var equip = equipped[key]
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
	if not r_arm:return
	var is_critical = is_critical_hit(r_arm.critical_chance)
	var d = r_arm.attack(is_critical)
	d += sum_array_with_reduce(plus_damage_array)
	main.mc._take_damage(d)


func _on_l_attack_timer_timeout() -> void:
	var l_arm: Node2D = $l_arm
	l_arm = l_arm.get_child(0)
	if not l_arm:return
	var is_critical = is_critical_hit(l_arm.critical_chance)
	var d = l_arm.attack(is_critical)
	d += sum_array_with_reduce(plus_damage_array)
	main.mc._take_damage(d)
