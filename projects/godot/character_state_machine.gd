extends Node2D

# 动作发生变化时，调用 change_state，决定是否变化
# 决定变化时，使用各动作脚本结束原本动作，和开始新动作函数
# 各状态处理自身间隔，有极小延迟，避免同时两次请求

# 尝试使用互斥锁
var mutex = Mutex.new()

@export var character_state = "idle"

var _character_move : Node2D
var _character_attack : Node2D
var _character_health : Node2D

func _ready():
	_character_move = get_parent().get_node("CharacterMove")
	_character_attack = get_parent().get_node("CharacterAttack")
	_character_health = get_parent().get_node("CharacterHealth")

# 检查状态是否能改变
func change_state(new_state, act_end=false):
	mutex.lock()
	match character_state:
		"idle":
			character_state = new_state
			_character_move.end_idle_act()
			change_act(new_state)

		"move":
			character_state = new_state
			_character_move.end_move_act()
			change_act(new_state)

		"attack":
			if act_end or (new_state == "hurt" or character_state == "die"):
				character_state = new_state
				_character_attack.end_attack_act()
				change_act(new_state)

		"hurt":
			if act_end or new_state == "die":
				character_state = new_state
				_character_health.end_hurt_act()
				change_act(new_state)

		"die":
			pass

		_:
			print("character_state_machine.gd character_state 出现异常")
			character_state = new_state
			_character_move.end_idle_act()
			change_act(new_state)

	mutex.unlock()

# 改变动作
func change_act(new_state):
	match new_state:
		"idle":
			_character_move.start_idle_act()
		"move":
			_character_move.start_move_act()
		"attack":
			_character_attack.start_attack_act()
		"hurt":
			_character_health.start_hurt_act()
		"die":
			_character_health.start_die_act()
		_:
			print("character_state_machine.gd new_state 出现异常")
