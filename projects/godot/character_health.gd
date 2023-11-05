extends Node2D

var _character : CharacterBody2D
var _character_state_machine : Node2D
var _character_ani : Node2D
var _hurt_timer : Timer

var max_health = 200
var defense_rate = 0.1
var defense_value = 5.0
@export var current_health : int = 200

@export var damage : int
@export var is_hurt : bool = false
@export var is_die : bool = false

func _ready():
	_character = get_parent()
	_character_state_machine = get_parent().get_node("CharacterStateMachine")
	_character_ani = get_parent().get_node("CharacterAni")
	_hurt_timer = get_parent().get_node("hurt_timer")

# ===============================
# hurt
# 即将受伤时，调用 start_hurt_state

func start_hurt_state(new_damage=1):
	if not is_hurt:
		damage = new_damage
		_character_state_machine.change_state("hurt")

func start_hurt_act():
	is_hurt = true
	var true_damage = int((damage - defense_value) * (1 - defense_rate))
	true_damage = max(1, true_damage)
	current_health = max(0, current_health - true_damage)
	if current_health <= 0:
		start_die_state()
	else:
		_hurt_timer.start()
		_character_ani.change_ani("hurt")

func end_hurt_act():
	is_hurt = false
	_hurt_timer.stop()

func _on_hurt_timer_timeout() -> void:
	is_hurt = false
	_character_state_machine.change_state("idle", true)

# ===============================
# die
# 即将死亡时，调用 start_die_state

func start_die_state():
	if not is_die:
		current_health = 0
		_character_state_machine.change_state("die")

func start_die_act():
	is_die = true
	_character_ani.change_ani("die")
	# 计时器，缓慢消失

func end_die_act():
	is_die = false
	_character.queue_free()


