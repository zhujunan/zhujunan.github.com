extends Node2D

var _character_move : Node2D
var _character_attack : Node2D
var _character_health : Node2D

var move_vector : Vector2

func _ready():
	_character_move = get_parent().get_node("CharacterMove")
	_character_attack = get_parent().get_node("CharacterAttack")
	_character_health = get_parent().get_node("CharacterHealth")

func _physics_process(_delta):
	check_move()
	#check_attack()
	check_hurt_for_test()
	check_die_for_test()

func check_move():
	var move_vector_new = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if move_vector_new != move_vector:
		move_vector = move_vector_new
		if move_vector_new != Vector2.ZERO:
			_character_move.start_move_state(move_vector)
		else:
			_character_move.start_idle_state()

func check_attack():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_character_attack.start_attack_state()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_character_attack.start_attack_state()

func check_hurt_for_test():
	if Input.is_key_pressed(KEY_H):
		_character_health.start_hurt_state()

func check_die_for_test():
	if Input.is_key_pressed(KEY_I):
		_character_health.start_die_state()
