extends Node2D
class_name Card

var world : Node2D
var group : int		# 1.控制 2.仅移动 3.中立 4.敌对
var tile_pos : Vector2i = Vector2i(-1, -1)

var card_name : String
var rare : int
var price : int
var max_health : int = 9999
var work_value : int = 9999
var work_speed : int = 1 # 角色：攻速，场地：工作速度
var first_rocovery_time : int = 10
var recovery_time : int = 1
var recovery_value : int = 1
var info : String

enum {IDLE,WORK,DIE}
var card_state := IDLE

var star : int = 1
var health_now
var work_value_now : int

func _ready() -> void:
	world = get_parent().get_parent()
	if !card_name:
		return
	var card_data = CardDict.CardDict[card_name]
	$BackGround/Unit.set_texture(card_data[0])
	rare = card_data[1]
	for i in range(rare + 1, 7):
		if randf() < 1/float(i + 1) and i == rare + 1:
			rare += 1
	price = card_data[2]
	max_health = card_data[3]
	work_value = card_data[4]
	
	health_now = max_health
	$RecoveryTimer.wait_time = first_rocovery_time
	set_card()

func health_change(hurt_damage : float) -> void:
	print(hurt_damage)
	if card_state == DIE:
		return
	health_now -= hurt_damage
	health_now = clamp(health_now, 0, max_health)
	var tween = create_tween()
	var health_pth : float = health_now / max_health
	tween.tween_property($BackGround/CardUI/HealthBar, "value", health_pth * 100, 0.1)
	if health_now < max_health:
		$BackGround/CardUI/HealthBar.visible = true
	else:
		tween.tween_property($BackGround/CardUI/HealthBar, "visible", false, 0.1)
	if health_now == 0:
		card_state = DIE
		#! 爆炸动画
		remove_card()
	elif health_now == max_health:
		$RecoveryTimer.stop()
		$BackGround/CardUI/HealthBar.visible = false
		$RecoveryTimer.wait_time = first_rocovery_time
	elif recovery_value > 0 and $RecoveryTimer.is_stopped():
		$RecoveryTimer.start()
	
func add_buff() -> void:
	pass
	
func set_card() -> void:
	var tile_pos_new : Vector2i = Vector2i(position / world.grid_size)
	if tile_pos_new == tile_pos:
		position = Vector2(tile_pos_new) * world.grid_size + world.grid_size/2
		return
	tile_pos_new = world.find_nearest_free_tile(tile_pos_new)
	world.occupied_tile[tile_pos_new.x][tile_pos_new.y] = self
	if tile_pos != Vector2i(-1,-1):
		world.occupied_tile[tile_pos.x][tile_pos.y] = null
	tile_pos = tile_pos_new
	position = Vector2(tile_pos_new) * world.grid_size + world.grid_size/2

func remove_card() -> void:
	world.occupied_tile[tile_pos.x][tile_pos.y] = null
	#! 卡牌消失动画
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	world.cursor_enter(self)
	world.show_info(info)

func _on_area_2d_mouse_exited() -> void:
	world.cursor_exit(self)
	world.show_info("")

func _on_recovery_timer_timeout() -> void:
	$RecoveryTimer.wait_time = recovery_time
	health_change(-recovery_value)

func _on_work_timer_timeout() -> void:
	work_value_now += work_speed
	work_value_now = clamp(work_value_now, 0, work_value)
	if work_value_now == work_value:
		work()
		work_value_now = 0

func work() -> void:
	pass
