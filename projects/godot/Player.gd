extends CharacterBody2D

signal life_changed(lives)
signal dead

# var body_textures={
# 	'head':'res://assets/sprites/cherry.png',
# 	'gem':'res://assets/sprites/gem.png'......
# }

var MOVE_SPEED = 10000

@onready var face_vector = Vector2.ZERO
@onready var face_left = true
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

@export var character_state = IDLE

# 人物属性
var healthMax = 100.0;
var healthCurrent = 100.0;
var healthRecovery = 0.0;
var healthRecoveryLockTime = 10.0;

var magicMax = 100.0;
var magicCurrent;
var magicRecovery = 10.0;
var magicRecoveryLockTime = 10.0;

var moveSpeed = 200;

var isAttack = false;
var isHurt = false;

var attack = 1.0;
var attackRange = 1.0;
var attackInterval = 0.6;
var attackSpeed = 1.0;

var magicAttack = 1.0;
var magicInterval = 1.0;
var magicSpeed = 1.0;
var magicCoolDownSpeed = 1.0;

var defense = 1.0;
var defensePCT = 1.0;
var hurtInterval = 0.65;

# 计算状态
# private int characterState = 1; // 1.idle, 2.move, 3.attack, 4.hit, 5.vanish 控制动画
# private int aniState = 1;
# private int weaponType = 1;

# 读取输入
# private Vector2 mouseDire = Vector2.down;
# private Vector2 movement;

# private Rigidbody2D rb;
# private Transform transf;
# private Animator playerAni;
# private Animator playerWeaponAni;
# private Animator playerCoverAni;

enum{IDLE,MOVE,ATTACK,HURT,DIE}

func get_vector_to_mouse():
	var character_position = get_position()
	var mouse_position = get_global_mouse_position()
	var vector_to_mouse = mouse_position - character_position
	
	var direction = Vector2.ZERO
	if abs(vector_to_mouse.x) >= abs(vector_to_mouse.y):
		if vector_to_mouse.x > 0:
			direction = Vector2.RIGHT
		elif vector_to_mouse.x < 0:
			direction = Vector2.LEFT
	else:
		if vector_to_mouse.y > 0:
			direction = Vector2.DOWN
		elif vector_to_mouse.y < 0:
			direction = Vector2.UP
	return direction

func change_face():
	if face_vector.x < 0 and not face_left:
		scale.x = -scale.x
		face_left = true
	elif face_vector.x > 0 and face_left:
		scale.x = -scale.x
		face_left = false

func _ready() -> void:
	change_state_ani(IDLE,"Idle",Vector2.ZERO)
	animationTree.active = true

func _physics_process(delta):
	if character_state == IDLE or MOVE:
		check_item()
		check_attack()
		if character_state != ATTACK:
			check_move_idle(delta)
	change_face()

# 待完善
func check_item():
	pass

func check_attack():
	if Input.is_action_pressed("input_normal_attack"):
		physical_attack(1)
	elif  Input.is_action_pressed("input_special_attack"):
		physical_attack(2)
	elif Input.is_action_pressed("input_magic_attack"):
		magical_attack(1)
	elif Input.is_action_pressed("input_special_magic"):
		magical_attack(2)

func change_state_ani(new_state, new_ani,new_face_vector):
	if new_state == character_state and new_face_vector == face_vector:
		return
	character_state = new_state
	face_vector = new_face_vector
	var anitreeblend = "parameters/"+ new_ani +"/blend_position"
	animationTree.set(anitreeblend, face_vector)
	animationState.travel(new_ani)

# 检查并执行move或idle操作
func check_move_idle(delta):
	var move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if move_vector != Vector2.ZERO:
		velocity = move_vector * MOVE_SPEED * delta
		move_and_slide()
		change_state_ani(MOVE,"Walk",move_vector)
	# elif character_state == MOVE:
	else:
		change_state_ani(IDLE,"Idle",get_vector_to_mouse())
	
# 待完善
func physical_attack(mode=1):
	change_state_ani(ATTACK,"Slash",get_vector_to_mouse())

# 待完善
func magical_attack(mode=1):
	pass

# 待完善
func hurt(life):
	# emit_signal('life_changed',life)

	# 击退
	# velocity.y=-200
	# velocity.x=-100*sign(velocity.x)
	life-=1
	# emit_signal('life_changed',life)
	# await(get_tree().create_timer(.5),'timeout')
	# change_state(IDLE)
	if life<=0:
	#  	change_state(DEAD)
	# DEAD:
	# 	emit_signal('dead')
		hide()

	change_state_ani(HURT,"Hurt",face_vector)

func hurt_interval_waiter():
	# await ToSignal(get_tree().create_timer(hurtInterval), "timeout")
	pass
	
#func _on_Hurtbox_area_entered(area):
#	stats.health -= area.damage
#	hurtbox.start_invincibility(0.6)
#	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instance()
#	get_tree().current_scene.addw(playerHurtSound)

# updateWeaponType（）idle 状态，获取input
