extends Node2D

const grid_num = Vector2i(40, 40)
const grid_size = Vector2(420, 524) / 0.8

const custom_cursor_1 = preload("res://UI/cursor_1.png")
const custom_cursor_2 = preload("res://UI/cursor_2.png")
const custom_cursor_3 = preload("res://UI/cursor_3.png")
@onready var main_camera : Camera2D = $Camera2D
@onready var grid : Node2D = $Grid
@onready var all_cards : Node = $Cards

var cursor_select_list : Array[Node2D]
var occupied_tile = []
var is_pressed : bool = false
var select_card : Node2D = null
var card_offset : Vector2

var Inventory : Dictionary= {}

func _ready() -> void:
	Input.set_custom_mouse_cursor(custom_cursor_1, Input.CURSOR_ARROW)
	init_occupied_tile()

func show_message(new_message : String, new_level : int) -> void:
	pass

func show_info(new_message : String) -> void:
	$UI/Info.text = new_message

### =============================================================
### 输入控制
func cursor_enter(card : Node2D) -> void:
	cursor_select_list.append(card)
	if is_pressed:
		return
	if select_card and select_card.position.y < card.position.y:
		card_deselect(select_card)
		card_select(card)
	else :
		card_select(card)
	Input.set_custom_mouse_cursor(custom_cursor_2, Input.CURSOR_ARROW)

func cursor_exit(card : Node2D) -> void:
	cursor_select_list.erase(card)
	if is_pressed:
		return
	if select_card != card:
		return
	card_deselect(card)
	if cursor_select_list:
		select_card = cursor_select_list[0]
		for other_card in cursor_select_list:
			if select_card.position.y < other_card.position.y:
				select_card = other_card
		card_select(select_card)
	else:
		Input.set_custom_mouse_cursor(custom_cursor_1, Input.CURSOR_ARROW)

func card_select(card : Node2D) -> void:
	select_card = card
	select_card.z_index = 10
	card.get_child(0, true).position = -Vector2(8, 8)

func card_deselect(card : Node2D) -> void:
	select_card = null
	card.z_index = 0
	card.get_child(0, true).position = Vector2(0, 0)

func _unhandled_input(event)-> void:
	if event is InputEventMouseButton:
		if event.button_index == 3:
			main_camera.camera_zoom(0)
		elif event.button_index == 4:
			main_camera.camera_zoom(1)
		elif event.button_index == 5:
			main_camera.camera_zoom(-1)
		elif event.pressed and event.button_index == 1:
			Input.set_custom_mouse_cursor(custom_cursor_3, Input.CURSOR_ARROW)
			is_pressed = true
			if select_card:
				grid.visible = true
				card_offset = select_card.position - get_global_mouse_position()
		elif !event.pressed and event.button_index == 1:
			if select_card:
				grid.visible = false
				Input.set_custom_mouse_cursor(custom_cursor_2, Input.CURSOR_ARROW)
				select_card.call_deferred("set_card")
			else:
				Input.set_custom_mouse_cursor(custom_cursor_1, Input.CURSOR_ARROW)
			is_pressed = false
	elif event is InputEventMouseMotion and is_pressed:
		if select_card:
			select_card.position = get_global_mouse_position() + card_offset
		else:
			var mouse_motion = event as InputEventMouseMotion
			if main_camera:
				main_camera.position = main_camera.position - mouse_motion.relative / main_camera.zoom


### =============================================================
### 建筑控制
		
func init_occupied_tile()-> void:
	for i in range(grid_num.x):
		var inner_array : Array[Node2D] = []
		for j in range(grid_num.y):
			inner_array.append(null)
		occupied_tile.append(inner_array)
		
func find_nearest_free_tile(new_tile : Vector2i) -> Vector2i:
	var visited = []
	var queue = [new_tile,]

	while queue.size() > 0:
		var current_point = queue.pop_front()
		if visited.has(current_point) or \
			current_point.x < 0 or current_point.x > grid_num.x - 1 or \
			current_point.y < 0 or current_point.y > grid_num.y - 1:
			continue
		
		if !occupied_tile[current_point.x][current_point.y]:
			return current_point
		
		visited.append(current_point)
		var neighbors = [
			Vector2(current_point.x + 1, current_point.y),
			Vector2(current_point.x - 1, current_point.y),
			Vector2(current_point.x, current_point.y + 1),
			Vector2(current_point.x, current_point.y - 1)
		]
		for neighbor in neighbors:
			if neighbor.x >= 0 and neighbor.x < grid_size.x and neighbor.y >= 0 and neighbor.y < grid_size.y:
				if !visited.has(neighbor):
					queue.push_back(neighbor)
	return Vector2i.ONE

func find_group_tile(new_tile:Vector2i, group:int, min_interval:int, max_interval:int) -> Vector2i:
	if occupied_tile[new_tile.x][new_tile.y]:
		return Vector2i.ZERO
	else:
		return Vector2i.ONE

func auto_create_card() -> void:
	var min_interval : int = 1
	var max_interval : int = 2
	var create_available_tiles : Array[Vector2i] = []
	var to_close_tiles : Array[Vector2i] = []
	var target_tiles : Array[Vector2i] = []
	
	var cards := all_cards.get_children()
	for tmp_card in cards:
		var card_tile : Vector2i = Vector2i(tmp_card.position / grid_size)
		for i in range(min_interval + 1):
			for j in range(i + 1):
				if (card_tile + Vector2i(j, i - j)).x >= 0 and (card_tile + Vector2i(j, i - j)).x < grid_num.x \
				and (card_tile + Vector2i(j, i - j)).y >= 0 and (card_tile + Vector2i(j, i - j)).y < grid_num.y:
					to_close_tiles.append((card_tile + Vector2i(j, i - j)))
				if (card_tile + Vector2i(-j, i - j)).x >= 0 and (card_tile + Vector2i(-j, i - j)).x < grid_num.x \
				and (card_tile + Vector2i(-j, i - j)).y >= 0 and (card_tile + Vector2i(-j, i - j)).y < grid_num.y:
					to_close_tiles.append((card_tile + Vector2i(-j, i - j)))
				if (card_tile + Vector2i(j, -i + j)).x >= 0 and (card_tile + Vector2i(j, -i + j)).x < grid_num.x \
				and (card_tile + Vector2i(j, -i + j)).y >= 0 and (card_tile + Vector2i(j, -i + j)).y < grid_num.y:
					to_close_tiles.append((card_tile + Vector2i(j, -i + j)))
				if (card_tile + Vector2i(-j, -i + j)).x >= 0 and (card_tile + Vector2i(-j, -i + j)).x < grid_num.x \
				and (card_tile + Vector2i(-j, -i + j)).y >= 0 and (card_tile + Vector2i(-j, -i + j)).y < grid_num.y:
					to_close_tiles.append((card_tile + Vector2i(-j, -i + j)))

		for i in range(min_interval + 1, max_interval + 1):
			for j in range(i + 1):
				if (card_tile + Vector2i(j, i - j)).x >= 0 and (card_tile + Vector2i(j, i - j)).x < grid_num.x \
				and (card_tile + Vector2i(j, i - j)).y >= 0 and (card_tile + Vector2i(j, i - j)).y < grid_num.y:
					create_available_tiles.append((card_tile + Vector2i(j, i - j)))
				if (card_tile + Vector2i(-j, i - j)).x >= 0 and (card_tile + Vector2i(-j, i - j)).x < grid_num.x \
				and (card_tile + Vector2i(-j, i - j)).y >= 0 and (card_tile + Vector2i(-j, i - j)).y < grid_num.y:
					create_available_tiles.append((card_tile + Vector2i(-j, i - j)))
				if (card_tile + Vector2i(j, -i + j)).x >= 0 and (card_tile + Vector2i(j, -i + j)).x < grid_num.x \
				and (card_tile + Vector2i(j, -i + j)).y >= 0 and (card_tile + Vector2i(j, -i + j)).y < grid_num.y:
					create_available_tiles.append((card_tile + Vector2i(j, -i + j)))
				if (card_tile + Vector2i(-j, -i + j)).x >= 0 and (card_tile + Vector2i(-j, -i + j)).x < grid_num.x \
				and (card_tile + Vector2i(-j, -i + j)).y >= 0 and (card_tile + Vector2i(-j, -i + j)).y < grid_num.y:
					create_available_tiles.append((card_tile + Vector2i(-j, -i + j)))

	for i in create_available_tiles:
		if i not in to_close_tiles and i not in target_tiles:
			target_tiles.append(i)

	if len(target_tiles) == 0:
		if len(cards) == 0:
			target_tiles.append(Vector2i.ZERO)
		else:
			show_message("场地已满，无法生成新卡牌", 3)
			return
			
	var card : PackedScene = load("res://Scene/NatureCard.tscn")
	var instance = card.instantiate()
	instance.card_name = "yew_forest"
	instance.position = Vector2(target_tiles.pick_random()) * grid_size + grid_size/2
	all_cards.add_child(instance)
	
