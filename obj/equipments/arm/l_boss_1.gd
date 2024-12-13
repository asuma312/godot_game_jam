extends Node2D

var type = "l_arm"
var hp = 30
var attack_speed = 1
var critical_chance = 30
var damage = 5

func attack(is_critical:bool):
	if is_critical:
		damage *= 2
	#play animation
	return damage
