extends CharacterBody2D
class_name Unit

enum {idle, move, attack, die}

@onready var parent : = self.get_parent()
@onready var ammo_born : Node2D = $AmmoBorn

@onready var body_ani : AnimatedSprite2D = $BodyAni
@onready var fire_effect_ani : AnimatedSprite2D = $FireEffectAni

# data parameters
var unit_name : String
var unit_level : int = 1
var health : float
var move_speed : int = 100
var defense : int
var damage : int
var unit_exp : int
var ammo_load = null

var unit_size : Vector2i = Vector2i.ONE

# calculate parameters
@export var target_group : String
@export var unit_state : = idle
@export var attack_target_list : Array[CharacterBody2D] = []
@export var move_target : CharacterBody2D = null
@export var attack_target : CharacterBody2D = null

func _ready() -> void:
	pass

func init_unit(new_unit_name : String = "", new_group : String = "", new_level=1) -> void:
	if new_unit_name:
		unit_name = new_unit_name
		var unit_info = GameData.UnitInfo[new_unit_name]
		health = unit_info[0]
		damage = unit_info[1]
		var attack_range = unit_info[2]
		defense = unit_info[3]
		if unit_info[4]:
			ammo_load = GameScenes.AmmoScenes[unit_info[4]]

		var shape1 = CircleShape2D.new()
		shape1.radius = attack_range * 64
		$AttackRange.get_node("CollisionShape2D").shape = shape1

	if new_group:
		add_to_group(new_group)
	
	if new_level:
		unit_level = new_level
		match unit_level:
			2:
				var frame_loc = "res://Resources/Soldier/Color1/Level2/"+ unit_name +"Ani.tres"
				var spriteFrames = ResourceLoader.load(frame_loc)
				body_ani.sprite_frames = spriteFrames
			3:
				var frame_loc = "res://Resources/Soldier/Color2/Level1/"+ unit_name +"Ani.tres"
				var spriteFrames = ResourceLoader.load(frame_loc)
				body_ani.sprite_frames = spriteFrames
			4:
				var frame_loc = "res://Resources/Soldier/Color4/Level1/"+ unit_name +"Ani.tres"
				var spriteFrames = ResourceLoader.load(frame_loc)
				body_ani.sprite_frames = spriteFrames
			5:
				var frame_loc = "res://Resources/Soldier/Color4/Level2/"+ unit_name +"Ani.tres"
				var spriteFrames = ResourceLoader.load(frame_loc)
				body_ani.sprite_frames = spriteFrames	
				
	if self.is_in_group("Enemy") and unit_name:
		target_group = "Ally"
		var frame_loc = "res://Resources/Soldier/Color5/Level1/"+ unit_name +"Ani.tres"
		var spriteFrames = ResourceLoader.load(frame_loc)
		body_ani.sprite_frames = spriteFrames
		
		var shape1 = CircleShape2D.new()
		shape1.radius = GameData.UnitInfo[unit_name][2] * 64 - 5
		$AttackRange.get_node("CollisionShape2D").shape = shape1
		
	elif self.is_in_group("Ally") and unit_name:
		target_group = "Enemy"

func _process(_delta : float) -> void:
	change_state()
	match unit_state:
		idle:
			pass
		move:
			self.look_at(move_target.position)
			var direction : Vector2 = (move_target.global_position - global_position).normalized()
			velocity = direction * move_speed
			move_and_slide()
		attack:
			self.look_at(attack_target.position)

func change_state() -> void:
	match unit_state:
		idle:
			if !attack_target_list.is_empty():
				unit_state = attack
				get_attack_target()
				body_ani.play("EnterAttack")
			elif self.is_in_group("Enemy") and !GameData.ally_list.is_empty():
				unit_state = move
				get_move_target()
				body_ani.play("Move")
		move:
			if !attack_target_list.is_empty():
				unit_state = attack
				get_attack_target()
				body_ani.play("EnterAttack")
			if !move_target or move_target.is_queued_for_deletion():
				if self.is_in_group("Enemy") and GameData.ally_list.is_empty():
					unit_state = idle
					body_ani.play("Idle")
				else:
					get_move_target()
		attack:
			if !attack_target or attack_target not in attack_target_list or attack_target.is_queued_for_deletion():
				if attack_target_list.is_empty():
					unit_state = idle
					body_ani.play("Idle")
				else:
					get_attack_target()
		die:
			pass

func get_move_target() -> void:
	move_target = GameData.ally_list[0]
	var min_distance : float = global_position.distance_to(GameData.ally_list[0].global_position)

	for target in GameData.ally_list:
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

func hurt(hurt_damage : int, source : CharacterBody2D) -> void:
	health -= hurt_damage - defense
	if health <= 0 and body_ani.animation != "Die":
		body_ani.play("Die")
		GameData.ally_list.erase(self)
		GameData.enemy_list.erase(self)
		if is_in_group("Enemy"):
			source.get_exp(GameData.UnitBasicInfo[unit_name][0])
			

func get_exp(new_exp : int) -> void:
	unit_exp += new_exp
	var next_level_exp : int = unit_level * unit_level * GameData.UnitBasicInfo[unit_name][0]
	if unit_exp > next_level_exp:
		unit_exp -= next_level_exp
		unit_level += 1
		init_unit("","", unit_level)

func _on_body_ani_animation_finished() -> void:
	if body_ani.animation == "Die":
		queue_free()
	if unit_state!=attack:
		return
	match body_ani.animation:
		"EnterAttack":
			body_ani.play("AttackStart")
		"AttackStart":
			body_ani.play("AttackShot")
			if ammo_load:
				var ammo_instance = ammo_load.instantiate()
				parent.add_child(ammo_instance)
				ammo_instance.global_position = ammo_born.global_position
				ammo_instance.unit_init(attack_target, damage, target_group, self)
			else:
				attack_target.call_deferred("hurt", damage, self)
			if fire_effect_ani.animation != "None":
				fire_effect_ani.visible = true
				fire_effect_ani.play()
		"AttackShot":
			body_ani.play("AttackEnd")
		"AttackEnd":
			if attack_target.is_queued_for_deletion():
				if attack_target_list.is_empty():
					body_ani.play("ExitAttack")
				else:
					get_attack_target()
			else:
				body_ani.play("AttackStart")
		"ExitAttack":
			unit_state = idle
			body_ani.play("Idle")

func _on_attack_target_entered(body) -> void:
	if body.is_in_group(target_group):
		attack_target_list.append(body)

func _on_attack_target_exited(body) -> void:
	if body.is_in_group(target_group):
		attack_target_list.erase(body)

func unit_selected() -> void:
	pass	
