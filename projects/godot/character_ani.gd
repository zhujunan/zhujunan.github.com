extends Node2D

# 状态发生变化时，调用 change_ani(动画名，新的方向)
# 需注意，方向改变也视作状态变化

# 人物后台属性
var animationTree : AnimationTree
var animationState : AnimationNodeStateMachinePlayback
var _character : CharacterBody2D
@export var face_left : bool = true
@export var face_vector : Vector2 = Vector2.LEFT
@export var ani_now : String = "idle"

func _ready() -> void:
	_character = get_parent() 
	animationTree = get_parent().get_node("AnimationTree")
	animationState = animationTree.get("parameters/playback")
	animationTree.active = true
	change_ani("idle", Vector2.UP)

# 暂时未做向右动画，用向左动画代替
func change_face(new_face_vector:Vector2):
	if new_face_vector.x < 0 and not face_left:
		_character.scale.x = -_character.scale.x
		face_left = true
	elif new_face_vector.x > 0 and face_left:
		scale.x = -scale.x
		_character.scale.x = -_character.scale.x
		face_left = false

# 传入：动画名称、动画方向(任意方向)
func change_ani(new_ani:String, new_face_vector = null):
	if not new_face_vector:
		new_face_vector = face_vector
	# 可循环动作，重复执行会跳过
	if (new_ani == "idle" or new_ani == "walk") and (new_ani == ani_now):
		return
	ani_now = new_ani
	face_vector = new_face_vector
	var anitreeblend = "parameters/" + new_ani + "/blend_position"
	animationTree.set(anitreeblend, face_vector)
	animationState.travel(new_ani)
	change_face(new_face_vector)
