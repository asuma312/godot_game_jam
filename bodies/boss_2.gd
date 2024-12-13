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

var default_position = Vector2(-31.368,-23.26)
var attack_position = Vector2(-41.597,-45.063)

var b_default_position = Vector2(23,-12)
var b_attack_position = Vector2(6,-31)

var r_arm
var l_arm
func _ready() -> void:
	self.scale = Vector2(3,3)
	r_arm = $r_arm/img
	l_arm = $l_arm/img
	l_arm.connect("animation_changed",_on_l_arm_animation_changed)
	r_arm.connect("animation_changed",_on_r_arm_animation_changed)
	
	l_arm.connect("animation_finished",_on_l_arm_animation_finished)
	r_arm.connect("animation_finished",_on_r_arm_animation_finished)
		
	r_arm.position = b_default_position
	l_arm.position = default_position
	_setup_bodyparts()


		
func _attack() ->void:
	r_arm.play("upper")
	l_arm.play("jab")


func _on_attack_timer_timeout() -> void:
	_attack()


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

func _on_l_arm_animation_changed() -> void:
	var actual_animation = l_arm.animation
	l_arm.position = attack_position

func _on_l_arm_animation_finished() -> void:
	pass



func _on_r_arm_animation_changed() -> void:
	print("aa")
	var actual_animation = r_arm.animation
	r_arm.position = b_attack_position


func _on_r_arm_animation_finished() -> void:
	pass
