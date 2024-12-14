extends Node2D

@onready var parent:Node2D = self.get_parent()
@onready var _e: GridContainer = $bg/EQUIPS_MENU/_s/_e
@onready var character_menu: Panel = $bg/CHARACTER_MENU
@onready var mc: CharacterBody2D = $bg/CHARACTER_MENU/mc
@onready var boss_menu: FlowContainer = $battle_board/bosses_board/FlowContainer
@onready var camera: Camera2D = $Camera2D


var current_equip:Node2D
var current_bodypart:Button
var old_equip:Node2D
var old_equip_button:Button
var old_pos:Vector2

var camera_position:Vector2
var old_camera_position:Vector2
var is_moving_camera:bool = false
var camera_move_speed = 8
var selected_boss
func _ready()->void:
	_setup_equips_menu()
	_setup_character_menu_buttons()
	_setup_boss_menu()
	parent.mc = mc
	

func _setup_boss_menu()->void:
	for children in boss_menu.get_children():
		if children is Button:
			children.pressed.connect(_on_boss_button_pressed.bind(children.name))
	
	
	
func _on_boss_button_pressed(boss_index):
	selected_boss = str(boss_index)

func _process(delta: float) -> void:
	if current_equip:
		current_equip.global_position = get_global_mouse_position()
	if is_moving_camera:
		move_camera_to_position(delta)


func _setup_equips_menu() -> void:
	var equips_array: Array = parent.equipments
	for equip: Node2D in equips_array:
		var t_button: Button = load("res://scenes/equipment_button.tscn").instantiate()
		t_button.item = equip
		_setup_single_button_equips_menu(t_button,equip)

		
func _setup_single_button_equips_menu(t_button:Button,equip:Node2D)->void:
		t_button.custom_minimum_size = Vector2(100, 100)
		if equip.is_node_ready():
			return
		t_button.add_child(equip)
		equip.scale = Vector2(0.08,0.08)
		equip.position = Vector2(
			t_button.custom_minimum_size.x / 2 - equip.position.x,
			t_button.custom_minimum_size.y / 2 - equip.position.y
		)
		_e.add_child(t_button)
		t_button.button_down.connect(_on_equips_menu_press_button.bind(equip,t_button))
		t_button.button_up.connect(_on_equips_menu_let_button)


func _on_equips_menu_press_button(_base_equi,button):
	var equipment = Globals._dup_obj(_base_equi)
	parent.add_child(equipment)
	current_equip = equipment
	equipment.scale = Vector2(0.08,0.08)
	old_equip_button = button
	old_equip = _base_equi
	current_equip.top_level = true

func return_equip_to_equips_menu(_body_part):
	var _old_equipment = parent.equipped[_body_part.name]
	var new_equipment = Globals._dup_obj(_old_equipment)
	parent.equipments.append(new_equipment)
	var _t_button = Button.new()
	await _setup_single_button_equips_menu(_t_button,new_equipment)
	_body_part.remove_child(_body_part.get_child(0))

func _on_equips_menu_let_button():
	var body_part = detect_body_part()
	if body_part:
		var sfx: AudioStreamPlayer = $sfx
		sfx.play()
		var _body_part:Button = body_part
		var new_equip = Globals._dup_obj(current_equip)
		if _body_part.get_children().size() > 0:
			await return_equip_to_equips_menu(_body_part)
		var _mc_body_part = mc.get_node(str(body_part.name))
		for children in _mc_body_part.get_children():
			_mc_body_part.remove_child(children)
		body_part.add_child(new_equip)
		new_equip.scale = Vector2(0.08,0.08)
		new_equip.global_position = _body_part.global_position + _body_part.get_rect().size / 2
		old_equip_button.queue_free()

		parent.equipments.erase(old_equip)
		parent.equipped[body_part.name] = new_equip
		mc._setup_equipments()
		_setup_character_menu_buttons()
	current_equip.queue_free()
	current_equip = null
	old_equip_button = null
	old_equip = null

		

		
	
func detect_body_part():
	var possible_children = character_menu.get_children()
	var mouse_position = get_global_mouse_position()
	
	for child in possible_children:
		if child is Button and child.get_global_rect().has_point(mouse_position):
			if not current_equip:return
			if child.name == current_equip.type:
				return child
	return false


func _setup_character_menu()->void:
	var equiped_dict:Dictionary = parent.equipped
	for key in equiped_dict:
		
		var weapon:Node2D = equiped_dict[key]
		if not weapon:
			return
		var node = character_menu.get_node(key)
		if node.get_child(0):
			node.remove_child(node.get_child(0))
		node.add_child(weapon)
func disconnect_all(sig:Signal):
	for dict in sig.get_connections():
		sig.disconnect(dict.callable)

func _setup_character_menu_buttons()->void:
	for button in character_menu.get_children():
		if button is not Button:
			continue
		if button.name == 'attack':
			continue
		var selected_equip = parent.equipped[button.name]

		disconnect_all(button.button_down)
		disconnect_all(button.button_up)
			
		button.button_down.connect(_on_character_menu_press_button.bind(button))
		button.button_up.connect(_on_character_menu_let_button)

func _on_character_menu_press_button(button)->void:
	var equipment = button.get_child(0)
	if not equipment:return
	current_bodypart = button
	old_pos = equipment.global_position
	current_equip = equipment
	current_equip.top_level = true
	
func _on_character_menu_let_button()->void:
	var body_part = detect_body_part()
	if body_part:
		if body_part == current_bodypart:
			current_equip.global_position = old_pos
			current_equip = null
			return
	if not current_bodypart:return
	var old_equips = null
	parent.equipped[current_bodypart.name] = null
	var button = Button.new()
	var new_equip = Globals._dup_obj(current_equip)
	_setup_single_button_equips_menu(button,new_equip)
	parent.equipments.append(new_equip)
	mc._remove_equipment(current_bodypart)
	current_equip.queue_free()
	current_equip = null



func _on_button_pressed() -> void:
	mc._attack()


func _on_go_to_boss_button_pressed() -> void:
	old_camera_position = camera.global_position
	camera_position = Vector2(1730,326)
	is_moving_camera = true

func move_camera_to_position(delta):
	if camera.global_position != camera_position:
		camera.global_position = camera.global_position.lerp(camera_position, camera_move_speed * delta)
	else:
		is_moving_camera = false


func _on_back_to_equps_pressed() -> void:
	camera_position = old_camera_position
	is_moving_camera = true


func _on_go_button_pressed() -> void:
	if not selected_boss:
		return
	parent._start_battle(selected_boss)	
