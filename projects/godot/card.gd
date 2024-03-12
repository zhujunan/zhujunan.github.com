extends Node2D

var world : Node2D

var card_data
var group : int
var max_health : int

enum {IDLE,WORK,DIE}

var health_now
var rare
var tile_pos : Vector2i

var catd_state : = IDLE
var work_value_now : float = 0
var work_speed : float
var worker : Node2D
var material_card_dict : Dictionary
var product_card_dict : Dictionary

var material_dict : Dictionary
var procduct_dict : Dictionary
var use_self : bool
var work_requirement_dict : Dictionary

func _ready() -> void:
	world = get_parent().get_parent()
	if !card_data:
		visible = false
	else:
		group = card_data.group
		max_health = card_data.health
		$BackGround/Unit.set_texture(card_data.icon)
		set_card()
		
func _process(delta: float) -> void:
	pass

func health_change(hurt_damage : float) -> void:
	if catd_state == DIE:
		return
	health_now -= hurt_damage
	health_now = clamp(health_now, 0, max_health)
	var tween = create_tween()
	var health_pth = health_now / 100
	tween.tween_property($HealthBar, "value", health_now, 0.1)
	if health_now == 0:
		catd_state = DIE
		#! 爆炸动画
		remove_card()
	
func set_card() -> void:
	var tile_pos_new : Vector2i = Vector2i(position / world.grid_size)
	tile_pos_new = world.find_nearest_free_tile(tile_pos_new)
	world.occupied_tile[tile_pos_new.x][tile_pos_new.y] = self
	world.occupied_tile[tile_pos.x][tile_pos.y] = null
	tile_pos = tile_pos_new
	position = Vector2(tile_pos_new) * world.grid_size + world.grid_size/2

func remove_card() -> void:
	var tile_pos_new : Vector2i = Vector2i(position / world.grid_size)
	world.occupied_tile[tile_pos.x][tile_pos.y] = null
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	world.cursor_enter(self)

func _on_area_2d_mouse_exited() -> void:
	world.cursor_exit(self)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 2 and event.pressed:
		get_parent().get_node("UI/ItemWindow").visible = true

func select_work(recipe_id : int) -> void:
	pass
	#deselect_work()
	#var recipe_now = RecipeDict[card_data.recipe_list[recipe_id]]
	#material_dict = recipe_now[0]
	#procduct_dict = recipe_now[1]
	#use_self = recipe_now[2]
	#work_requirement_dict = recipe_now[3]
	#
	#material_card_dict = material_dict.duplicate(true)
	#for tmp_key in material_card_dict:
		#material_card_dict[tmp_key] = 0
	#product_card_dict = procduct_dict.duplicate(true)
	#for tmp_key in product_card_dict:
		#product_card_dict[tmp_key] = 0
		#$WorkInfo.set_recipe(material_dict, procduct_dict, work_requirement_dict)
	#start_work()

func deselect_work() -> void:
	catd_state = WORK
	$WorkInfo.unset_recipe()
	work_value_now = 0
	$WorkInfo.set_process(0)
	for tmp_material in material_card_dict:
		world.Inventory[tmp_material] = world.Inventory.get(tmp_material, 0) + material_card_dict[tmp_material]
		#! show_store_add(tmp_material, material_card_dict[tmp_material])
	material_card_dict.clear()
	for tmp_product in product_card_dict:
		world.Inventory[tmp_product] = world.Inventory.get(tmp_product, 0) + product_card_dict[tmp_product]
		#! show_store_add(tmp_material, material_card_dict[tmp_material])
	product_card_dict.clear()
	
func add_material(new_material : String, new_num : int):
	material_card_dict[new_material] += new_num
	if catd_state != WORK:
		start_work()
	#! $WorkInfo.set_material(material_dict, product_num_list, work_requirement_dict)

func start_work() -> void:
	work_speed = 2
	var multiple : int = 10
	for require_material in material_dict:
		if material_dict[require_material] > material_dict[require_material]:
			return
	for require_ability in work_requirement_dict:
		if work_requirement_dict[require_ability] > worker.require_ability:
			multiple = 0.5
		else:
			multiple = min(multiple, int(work_requirement_dict[require_ability] / worker.require_ability))

	work_speed = multiple * work_speed
	catd_state = WORK
	$Timer.start

func stop_work() -> void:
	$Timer.stop

func do_work() -> void:
	work_value_now += work_speed
	if work_value_now >= work_value_now:
		finish_work()
		start_work()

func finish_work() -> void:
	for require_material in material_dict:
		if material_card_dict[require_material] < material_dict[require_material]:
			return
		material_card_dict[require_material] -= material_dict[require_material]
		
	for tmp_product in procduct_dict:
		if procduct_dict[tmp_product] < 0:
			if randf() < procduct_dict[tmp_product]:
				product_card_dict[tmp_product] += 1
		else:
			product_card_dict[tmp_product] += procduct_dict[tmp_product]
	$WorkInfo.set_process(0)
	if use_self:
		remove_card()
	else:
		start_work()

func material_ani(material, num) -> void:
	$MaterialInfo.init(material, num)

# character 内容
#strength, agile, magic power,


