extends AnimatedSprite2D
var type = "l_arm"
var hp = 50
var attack_speed = 5
var critical_chance = 5
var damage = 9
var _name = "Juliter left arm"
var atts = [
	{"HP": hp},
	{"Attack Speed": attack_speed},
	{"Critical Chance": critical_chance},
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
