extends AnimatedSprite2D
var type = "l_arm"
var hp = 35
var attack_speed = 1.0
var critical_chance = 20
var damage = 6
var atts = [
	{"HP": hp},
	{"Attack Speed": attack_speed},
	{"Critical Chance": critical_chance},
	{"Damage": damage}
]
var _name = "Zangbeto left arm"
func attack(is_critical: bool):
	var total_damage = damage
	if is_critical:
		total_damage *= 2
	play("jab")
	return total_damage
