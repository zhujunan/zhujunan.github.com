extends CharacterBody2D
class_name Unit

enum {idle, move, attack}

@onready var ammo_born : Node = $AmmoBorn

@onready var idle_ani : AnimatedSprite2D = $IdleAni
@onready var move_ani : AnimatedSprite2D = $MoveAni
@onready var attack_ani : AnimatedSprite2D = $AttackAni
@onready var fire_effect_ani : AnimatedSprite2D = $FireEffectAni # -> attack_cool()

@onready var attack_start_timer : Timer = $AttackStartTimer # timeout # -> attack_shot()
@onready var attack_cool_timer : Timer = $AttackCoolTimer # timeout # -> attack_end()

# data parameters
var health : float
var move_speed : int
var armor : float
var defense : float
var addition_damage : float
var ammo_load

# calculate parameters
@export var target_group : String
@export var unit_state = idle
@export var attack_target_list : Array[CharacterBody2D] = []
@export var move_target_list : Array[CharacterBody2D] = []
@export var move_target : CharacterBody2D = null
@export var attack_target : CharacterBody2D = null
@onready var is_attack : bool = false

func _ready() -> void:
	pass

func _process(delta : float) -> void:
	change_state()
	match unit_state:
		idle:
			unit_idle()
		move:
			unit_move(delta)
		attack:
			unit_attack()

func init_unit(new_health = 100, new_move_speed = 100, new_armor = 1, new_defense = 1,
 			   new_addition_damage = 10, new_ammo_load = null) -> void:
	health = new_health
	move_speed = new_move_speed
	armor = new_armor
	defense = new_defense
	addition_damage = new_addition_damage
	ammo_load = new_ammo_load

func init_group(new_group : String) -> void:
	add_to_group(new_group)
	if self.is_in_group("Enemy"):
		target_group = "Ally"
	elif self.is_in_group("Ally"):
		target_group = "Enemy"

func change_state() -> void:
	match unit_state:
		idle:
			# 被其它状态覆盖
			if !attack_target_list.is_empty():
				exit_idle()
				enter_attack()
			if !move_target_list.is_empty():
				exit_idle()
				enter_move()
		move:
			# 被其它状态覆盖
			if !attack_target_list.is_empty():
				exit_move()
				enter_attack()

			# 主动退出状态
			if move_target.is_queued_for_deletion():
				exit_move()
				enter_idle()
		attack:
			# 主动退出状态
			if !is_attack and attack_target.is_queued_for_deletion():
				exit_attack()
				enter_idle()

func enter_idle() -> void:
	unit_state = idle
	idle_ani.visible = true
	idle_ani.play()

func enter_move() -> void:
	unit_state = move
	get_move_target()
	move_ani.visible = true
	move_ani.play()

func enter_attack() -> void:
	unit_state = attack
	get_attack_target()
	attack_ani.visible = true
	attack_ani.play()

func exit_idle() -> void:
	move_ani.visible = false

func exit_move() -> void:
	move_ani.visible = false

func exit_attack() -> void:
	attack_ani.visible = false

func hurt(damage) -> void:
	health -= damage * armor - defense
	if int(health) <= 0:
		# 创建消失动画
		queue_free()

func unit_idle() -> void:
	pass

func unit_move(delta) -> void:
	self.look_at(move_target.position)
	self.rotate(deg_to_rad(-90))
	var direction : Vector2 = (move_target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_collide(velocity * delta)

func unit_attack() -> void:
	if !is_attack:
		attack_start()

# 播放角色攻击动画
func attack_start() -> void:
	is_attack = true
	self.look_at(attack_target.position)
	self.rotate(deg_to_rad(-90))

	attack_start_timer.start()
	# 或attack_shot()

# 角色开火动作结束后，播放攻击特效
func attack_shot() -> void:
	fire_effect_ani.visible = true
	fire_effect_ani.play()
	attack_ani.play()
	
	if ammo_load:
		var ammo_instance = ammo_load.instance()
		ammo_instance.global_position = ammo_born.global_position
		ammo_instance.target = attack_target
		ammo_instance.damage += addition_damage
		add_child(ammo_instance)
	else:
		attack_target.call_deferred("hurt", addition_damage)

# 攻击特效结束后，开始冷却
func attack_cool() -> void:
	fire_effect_ani.visible = false
	attack_cool_timer.start()
	# 或attack_end()

# 冷却结束
func attack_end() -> void:
	is_attack = false

func get_move_target() -> void:
	move_target = move_target_list[0]
	var min_distance : float = global_position.distance_to(move_target_list[0].global_position)

	for target in move_target_list:
		var distance : float = global_position.distance_to(target.global_position)
		if distance < min_distance:
			move_target = target
			min_distance = distance

func get_attack_target() -> void:
	attack_target = attack_target_list[0]
	var min_distance : float = global_position.distance_to(attack_target_list[0].global_position)

	for target in attack_target_list:
		var distance : float = global_position.distance_to(target.global_position)
		if distance < min_distance:
			attack_target = target
			min_distance = distance

func _on_move_target_entered(body) -> void:
	if body.is_in_group(target_group):
		move_target_list.append(body)

func _on_move_target_exited(body) -> void:
	if body.is_in_group(target_group):
		move_target_list.erase(body)

func _on_attack_target_entered(body) -> void:
	if body.is_in_group(target_group):
		attack_target_list.append(body)

func _on_attack_target_exited(body) -> void:
	if body.is_in_group(target_group):
		attack_target_list.erase(body)
