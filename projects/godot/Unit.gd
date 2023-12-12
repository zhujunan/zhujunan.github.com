extends CharacterBody2D
class_name Unit

enum {idle, moving, attacking}

@onready var attack_timer : Timer = $AttackTimer
@onready var unit_name : String = self.name

# data parameters
var health : int;
var move_speed : float;
var armor : int;
var defense : int;
var attack : int;
var bullet_type : String;

# calculate parameters
@export var unit_state = idle
var enemy_list = []
@export var moving_target : CharacterBody2D = null
@export var attacking_target : CharacterBody2D = null
@onready var has_target : bool = false
@onready var is_attack : bool = false
var attack_cooling : bool = false

func _ready() -> void:
	pass
	
func _process(delta) -> void:
	chang_state()
	match unit_state:
		idle:
			unit_idle()
		moving:
			unit_move(delta)
		attacking:
			unit_attack()

func chang_state() -> void:
	match unit_state:
		idle:
			if !enemy_list.is_empty():
				unit_state = attacking
				get_attacking_target()
			if moving_target and !moving_target.is_queued_for_deletion():
				unit_state = moving
				$MovingAni.visible = true
				$MovingAni.Play()
		moving:
			if !enemy_list.is_empty():
				unit_state = attacking
				$MovingAni.visible = false
				get_attacking_target()
			if moving_target.is_queued_for_deletion():
				unit_state = idle
				$MovingAni.visible = false
		attacking:
			if attacking_target.is_queued_for_deletion():
				unit_state = idle
	
func unit_idle() -> void:
	find_moving_target()

func unit_move(delta) -> void:
	self.look_at(moving_target.position)
	self.rotate(deg_to_rad(-90))
	var direction = (moving_target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_collide(velocity * delta)
	
func unit_attack() -> void:
	self.look_at(attacking_target.position)
	self.rotate(deg_to_rad(-90))
	$BodySprite.visible = false
	$FireBodyAni.visible = true
	$FireEffectAni.visible = true
	$FireBodyAni.play()
	$FireEffectAni.play()
	attack_timer.start()
	attack_cooling = true

	if bullet_type:
		var bulletInstance = GameData.Bullet.instance()
		bulletInstance.init_bullet(bullet_type)
		bulletInstance.global_position = $BulletBorn.global_position  # 设置子弹的初始位置
		bulletInstance.target = attacking_target
		bulletInstance.attack = attack
		add_child(bulletInstance)  # 将子弹添加到场景中
	else:
		attacking_target.call_deferred("hurt", attack)

# 暂时生成敌人时给出，己方不移动
func find_moving_target() -> void:
	pass

func get_attacking_target() -> void:
	attacking_target = enemy_list[0]
	var minDistance : float = global_position.distance_to(enemy_list[0].global_position)

	for enemy in enemy_list:
		var distance : float = global_position.distance_to(enemy.global_position)
		if distance < minDistance:
			attacking_target = enemy
			minDistance = int(distance)

func _on_enemy_entered(body) -> void:
	if body.is_in_group("Enemy"):
		enemy_list.append(body)

func _on_enemy_exited(body) -> void:
	if body.is_in_group("Enemy"):
		enemy_list.erase(body)

func _on_attack_timer_timeout() -> void:
	attack_cooling = false

func _on_fire_ani_animation_finished() -> void:
	$FireBodyAni.visible = false
	$BodySprite.visible = true

func _on_fire_effect_ani_animation_finished() -> void:
	$FireEffectAni.visible = false
