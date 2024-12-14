extends Node2D

var type = "l_arm"
var hp = 30
var attack_speed = 1
var critical_chance = 100
var damage = 5
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack(is_critical:bool):
	var new_damage = damage
	if is_critical:
		new_damage *= 2
		animation_player.play("upper")
	else:
		animation_player.play("jab")
	return damage
