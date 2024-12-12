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
	"head":preload("res://obj/equipments/head/boss_1.tscn").instantiate(),
	"l_arm":preload("res://obj/equipments/arm/l_boss_1.tscn").instantiate(),
	"l_leg":preload("res://obj/equipments/leg/l_boss_1.tscn").instantiate(),
	"armor":preload("res://obj/equipments/armor/boss_1.tscn").instantiate(),
	"r_arm":preload("res://obj/equipments/arm/r_boss_1.tscn").instantiate(),
	"r_leg":preload("res://obj/equipments/leg/r_boss_1.tscn").instantiate()
}

func _ready() -> void:
	self.scale = Vector2(3,3)
	animated_sprite_2d.play("uppercut")


		
func _attack() ->void:
	animation_player.play("upper_attack")


func _on_attack_timer_timeout() -> void:
	_attack()


func _on_attack_range_body_entered(body: Node2D) -> void:
	body._take_damage(damage)

func _take_damage(damage):
	print("took damage")
	var choose_body_part = body_parts.pick_random()
	var body_part = equipped[choose_body_part]
	body_part.hp -= damage
	if body_part.hp <= 0:
		lose_part.emit(body_part.get_parent())
		equipped.erase(choose_body_part)
		return
	took_damage.emit()



	

func _on_l_arm_animation_changed() -> void:
	var l_arm: AnimatedSprite2D = $l_arm/l_arm
	var actual_animation = l_arm.animation




func _on_animated_sprite_2d_animation_changed() -> void:
	var r_arm: AnimatedSprite2D = $r_arm/r_arm
	var actual_animation = r_arm.animation
