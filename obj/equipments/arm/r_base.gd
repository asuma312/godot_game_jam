extends AnimatedSprite2D

var type = "r_arm"
var hp = 30
var attack_speed = 1
var critical_chance = 0
var damage = 0
var _name = "Base right arm"
var atts = [
	{"HP":hp},
	{"Attack speed": attack_speed},
	{"Critical chance": critical_chance},
	{"Damage": damage}
]


func attack(is_critical:bool):
	var animation_player: AnimationPlayer = $AnimationPlayer

	if is_critical:
		damage *= 2
		animation_player.play("uppercut")
	else:
		animation_player.play("jab")

	return damage
