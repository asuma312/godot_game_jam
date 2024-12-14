extends AnimatedSprite2D
var type = "l_arm"
var hp = 30
var attack_speed = 1.0
var critical_chance = 70
var damage = 2
var _name = "Protoeva left arm"
var atts = [
	{"HP": hp},
	{"Attack Speed": attack_speed},
	{"Critical Chance": critical_chance},
	{"Damage": damage}
]
func attack(is_critical: bool):
	var total_damage = damage
	if is_critical:
		total_damage *= 2.5
		play("uppercut")
	else:
		play("jab")
	return total_damage
