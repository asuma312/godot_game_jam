extends AnimatedSprite2D
var type = "r_arm"
var hp = 20
var attack_speed = 0.3
var critical_chance = 60
var damage = 3
var _name = "Thor right arm"
var atts = [
	{"HP": hp},
	{"Attack Speed": attack_speed},
	{"Critical Chance": critical_chance},
	{"Damage": damage}
]
func attack(is_critical: bool):
	var total_damage = damage
	if is_critical:
		total_damage *= 1.5
		play("uppercut")
	else:
		play("jab")
	return total_damage
