extends AnimatedSprite2D

var type = "l_arm"
var hp = 30
var attack_speed = 2
var critical_chance = 20
var damage = 3
var _name = "Base left arm"
var atts = [
	{"HP":hp},
	{"Attack speed": attack_speed},
	{"Critical chance": critical_chance},
	{"Damage": damage}
]


func attack(is_critical: bool):
	var total_damage = damage
	if is_critical:
		total_damage *= 2
		play("uppercut")
	else:
		play("jab")
	return total_damage
