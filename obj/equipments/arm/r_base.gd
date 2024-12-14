extends AnimatedSprite2D

var type = "r_arm"
var hp = 30
var attack_speed = 0.6
var critical_chance = 40
var damage = 4
var _name = "Base right arm"
var atts = [
	{"HP":hp},
	{"Attack speed": attack_speed},
	{"Critical chance": critical_chance},
	{"Damage": damage}
]
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func attack(is_critical: bool):
	var total_damage = damage
	if is_critical:
		total_damage *= 2.5
		play("uppercut")
	else:
		play("jab")
	return total_damage
