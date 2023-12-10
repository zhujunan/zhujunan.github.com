extends Node2D
class_name Unit

@onready var attack_timer : Timer = $AttackTimer
@onready var unit_name : String = self.name

var health : int;
var armor : int;
var attack : int;
var attack_interval : float;
var attack_range : int;
var fire_effect : String;
var bullet_type : String;

var attack_cooling : bool = false
var enemy_list = []
var target_enemy : CharacterBody2D = null
@onready var has_target : bool = false
@onready var is_attack : bool = false

func _ready() -> void:
	var data_list = GameData.unit_data[unit_name]
	health = data_list[0]
	armor = data_list[1]
	attack = data_list[2]
	attack_interval = data_list[3]
	attack_range = data_list[4]
	fire_effect =  data_list[5]
	bullet_type = data_list[6]
	
	$AttackTimer.wait_time = attack_interval
	var circle_shape : CircleShape2D = CircleShape2D.new()
	circle_shape.radius = attack_range
	$AttackRange.get_node("CollisionShape2D").shape = circle_shape
	
func _process(_delta) -> void:
	if !target_enemy:
		target_enemy = get_nearest_enemy_in_range()
	
	if target_enemy and !attack_cooling:
		shoot_bullet_at_enemy(target_enemy)

func get_nearest_enemy_in_range() -> CharacterBody2D:
	var nearestEnemy : CharacterBody2D = null
	var minDistance : int = 2 * attack_range

	for enemy in enemy_list:
		var distance : float = global_position.distance_to(enemy.global_position)
		if distance < minDistance:
			nearestEnemy = enemy
			minDistance = int(distance)
	return nearestEnemy

func shoot_bullet_at_enemy(enemy : CharacterBody2D) -> void:
	self.look_at(enemy.position)
	self.rotate(deg_to_rad(-90))
	$BodySprite.visible = false
	$FireBodyAni.visible = true
	$FireEffectAni.visible = true
	$FireBodyAni.play(unit_name)
	$FireEffectAni.play(fire_effect)
	attack_timer.start()
	attack_cooling = true
	
	var bulletInstance = GameData.Bullet.instance()
	bulletInstance.init_bullet(bullet_type)
	bulletInstance.global_position = $BulletBorn.global_position  # 设置子弹的初始位置
	bulletInstance.target = enemy
	bulletInstance.attack = attack
	add_child(bulletInstance)  # 将子弹添加到场景中

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
