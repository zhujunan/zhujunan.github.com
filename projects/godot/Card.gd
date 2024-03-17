extends Node2D
class_name Card

var world : Node2D
var group : int		# 1.控制 2.仅移动 3.中立 4.敌对
var tile_pos : Vector2i = Vector2i(-1, -1)

var card_name : String
var max_health : int = 9999
var work_value : int = 9999
var work_speed : int = 1 # 角色：攻速，场地：工作速度
var work_view : int = 1
var first_rocovery_time : int = 10
var recovery_time : int = 3
var recovery_value : int = 1
var info : String

enum {IDLE,WORK,DIE}
var card_state := IDLE

var star : int = 1
var health_now
var work_value_now : int

var all_function = []
var require_dict = {}
var product_dict = {}

func _ready() -> void:
	world = get_parent().get_parent()
	if !card_name : return
	set_card()
	
### =============================================================
### 底层功能

func health_change(hurt_damage : float) -> void:
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
		if card_state == WORK:
			cancel_work()
		card_state = DIE
		#! 爆炸动画
		remove_card()
	elif health_now == max_health:
		$RecoveryTimer.stop()
		$BackGround/CardUI/HealthBar.visible = false
		$RecoveryTimer.wait_time = first_rocovery_time
	elif recovery_value > 0 and $RecoveryTimer.is_stopped():
		$RecoveryTimer.start()

func set_card() -> void:
	var tile_pos_new : Vector2i = Vector2i(position / world.grid_size)
	if tile_pos_new == tile_pos:
		position = Vector2(tile_pos_new) * world.grid_size + world.grid_size/2
		return
	if card_state == WORK:
		cancel_work()
	tile_pos_new = world.find_nearest_free_tile(tile_pos_new)
	world.occupied_tile[tile_pos_new.x][tile_pos_new.y] = self
	if tile_pos != Vector2i(-1,-1):
		world.occupied_tile[tile_pos.x][tile_pos.y] = null
		for other_card in world.get_round_card(tile_pos, 3):
			other_card.all_function_activate()
	for other_card in world.get_round_card(tile_pos_new, 3):
		other_card.all_function_activate()
	tile_pos = tile_pos_new
	position = Vector2(tile_pos_new) * world.grid_size + world.grid_size/2
	check_work_start()

func remove_card() -> void:
	if card_state == WORK:
		cancel_work()
	world.occupied_tile[tile_pos.x][tile_pos.y] = null
	#! 卡牌消失动画
	queue_free()

### =============================================================
### 基本功能

func sell() -> void:
	var recover_dict = CardDict.CardDict[card_name][5]
	for tmp_product in recover_dict:
		world.store_change(tmp_product, recover_dict[tmp_product])
		show_product(tmp_product, recover_dict[tmp_product])
	remove_card()

### =============================================================
### 触发器

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
		check_work_continue()
		
func update_select() -> void:
	pass

func show_product(new_product_name, new_product_num) -> void:
	var cloned_node = $BackGround/CardUI/ShowProduct/OneProduct.duplicate()
	cloned_node.get_node("Pic").set_texture(load(ItemDict.ItemDict[new_product_name]))
	cloned_node.get_node("Num").text = "+ %d" % [new_product_num]
	add_child(cloned_node)
	cloned_node.position = Vector2(-100, 30)
	var tween = cloned_node.create_tween()
	tween.tween_property(cloned_node, "position", Vector2(-90,-150), 1.0)
	cloned_node.get_node("Timer").start()

### =============================================================
### Work

func all_function_activate() -> void:
	var card_data = CardDict.CardDict[card_name]
	max_health = card_data[3]
	work_value = card_data[4]
	health_now = max_health
	product_dict = {}
	require_dict = {}
	for i in CardFunction.BasicFunction[card_name]:
		one_function_activate(i)
	for i in all_function:
		one_function_activate(i)

func one_function_activate(new_function) -> void:
	var product_num : int = 1
	var tmp_require_list = new_function[3]
	var tmp_product_list = new_function[4]
	if !tmp_require_list:
		product_num = 1
	elif tmp_require_list is Array:
		var require_num = tmp_require_list[2]
		var has_require_value : int
		if tmp_require_list[1] == "self":
			has_require_value = get(tmp_require_list[0])
		elif tmp_require_list[1] == "around":
			has_require_value = len(world.get_round_card(tile_pos, work_view, tmp_require_list[0]))
		product_num = int(has_require_value / require_num)
		if product_num == 0:
			return
		if !new_function[2]:
			product_num = 1
	else:
		product_num = 1
		for i in tmp_require_list:
			require_dict[i] = require_dict.get(i, 0) + tmp_require_list[i]
	
	if tmp_product_list[1] == "self":
		if tmp_product_list[0] in ["max_health", "work_speed", "price", "work_view", "first_rocovery_time", "recovery_time", "recovery_value"]:
			if tmp_product_list[2] is int:
				set(tmp_product_list[0], get(tmp_product_list[0]) + tmp_product_list[2] * product_num)
			else:
				set(tmp_product_list[0], get(tmp_product_list[0]) * pow(tmp_product_list[2], product_num))
		else:
			product_dict[tmp_product_list[0]] = product_dict.get(tmp_product_list[0], 0) + tmp_product_list[2] * product_num
	elif tmp_product_list[1] == "around":
		for other_card in world.get_round_card(tile_pos, work_view, tmp_product_list[0]):
			if tmp_product_list[0] in ["max_health", "work_speed", "price", "work_view", "first_rocovery_time", "recovery_time", "recovery_value"]:
				other_card.set(tmp_product_list[0], other_card.get(tmp_product_list[0]) + tmp_product_list[2] * product_num)
			else:
				product_dict[tmp_product_list[0]] = product_dict.get(tmp_product_list[0], 0) + tmp_product_list[2] * product_num

func check_work_start() -> void:
	all_function_activate()
	if !require_dict:
		$WorkTimer.start()
		card_state = WORK
	for i in require_dict:
		if world.Inventory.get(i,0) < require_dict[i]:
			return
	for i in require_dict:
		world.store_change(i, -require_dict[i])
	$WorkTimer.start()
	card_state = WORK

func check_work_continue() -> void:
	cancel_work()
	check_work_start()

func cancel_work() -> void:
	$WorkTimer.stop()
	work_value_now = 0
	for i in require_dict:
		world.store_change(i, require_dict[i])

func work() -> void:
	var product_dict_copy = product_dict.duplicate()
	for tmp_product in product_dict_copy:
		if tmp_product == "health_now":
			health_now += product_dict_copy[tmp_product]
		elif product_dict_copy[tmp_product] == -1:
			CardCreator.change_card(self, tmp_product)			
		else:
			world.store_change(tmp_product, product_dict_copy[tmp_product])
			show_product(tmp_product, product_dict_copy[tmp_product])
	world.store_change("worker", require_dict.get("worker", 0))
	require_dict = {}
	
