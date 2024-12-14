extends AnimatedSprite2D
var type = "l_arm"
var hp = 30
var attack_speed = 0.8
var critical_chance = 0
var damage = 1
var _name = "Purple alien left arm"
var atts = [
	{"HP": hp},
	{"Attack Speed": attack_speed},
	{"Critical Chance": critical_chance},
	{"Damage": damage},
	{"Extra":"Apply poison on hit"}
]
var poison_stack:int = 0

func attack(is_critical:bool):
	poison_stack +=1
	var total_damage = damage
	if is_critical:
		total_damage *= 2
		play("uppercut")
	else:
		play("jab")
	
	total_damage += poison_stack * 5
	return total_damage
