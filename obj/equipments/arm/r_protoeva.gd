extends AnimatedSprite2D

var type = "r_arm"
var hp = 30
var attack_speed = 1.0
var critical_chance = 70
var damage = 1
var _name = "Protoeva right arm"
var atts = [
	{"HP":hp},
	{"Attack speed": attack_speed},
	{"Critical chance": critical_chance},
	{"Damage": damage}
]
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack(is_critical:bool):
	print("r attacking")
	if is_critical:
		damage *= 4
		play("upper")
	else:
		play("jab")

	return damage
