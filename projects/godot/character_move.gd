extends Node2D

var _character : CharacterBody2D
var _character_state_machine : Node2D
var _character_ani : Node2D

var move_speed = 10000

@export var move_vector : Vector2 = Vector2.ZERO
@export var ask_move_vector : Vector2 = Vector2.ZERO
@export var is_move : bool = false
@export var is_idle : bool = false

func _ready():
	_character = get_parent() 
	_character_state_machine = get_parent().get_node("CharacterStateMachine")
	_character_ani = get_parent().get_node("CharacterAni")

# ===============================
# move
# 请求移动时，调用 start_move_state

func start_move_state(new_move_vector):
	if is_move:
		move_vector = new_move_vector.normalized() * move_speed
		_character.move_vector = move_vector
		_character_ani.change_ani("move" , move_vector)
	else:
		ask_move_vector = new_move_vector
		_character_state_machine.change_state("move")

func start_move_act():
	is_move = true
	move_vector = ask_move_vector.normalized() * move_speed
	_character.move_vector = move_vector
	_character_ani.change_ani("move" , move_vector)

func end_move_act():
	is_move = false
	move_vector = Vector2.ZERO

# ===============================
# idle
# 结束移动时，调用 start_idle_state

func start_idle_state():
	if not is_idle:
		_character_state_machine.change_state("idle")

func start_idle_act():
	is_idle = true
	_character.move_vector = Vector2.ZERO
	_character_ani.change_ani("idle")

func end_idle_act():
	is_idle = false

