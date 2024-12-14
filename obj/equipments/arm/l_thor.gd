extends AnimatedSprite2D
var type = "l_arm"
var hp = 10
var attack_speed = 0.5
var critical_chance = 30
var damage = 4     
var _name = "Thor left arm"
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
