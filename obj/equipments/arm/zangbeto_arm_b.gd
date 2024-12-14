extends AnimatedSprite2D

var type = "r_arm"
var hp = 30
var attack_speed = 1
var critical_chance = 30
var damage = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack(is_critical:bool):
	var new_damage = damage
	if is_critical:
		new_damage *= 2
		animation_player.play("upper")
	else:
		animation_player.play("jab")
	return new_damage
