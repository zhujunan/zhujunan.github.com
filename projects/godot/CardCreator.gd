extends Node

var tile_card : PackedScene = preload("res://Scene/NatureCard.tscn")

func create_tile_card(card_name : String) -> Node2D:
	var instance : Node2D = tile_card.instantiate()
	var card_data = CardDict.CardDict[card_name]
	var rare = card_data[1]
	instance.get_node("BackGround/Unit").set_texture(card_data[0])
	instance.get_node("BackGround").set_texture(CardDict.tile_bg_pic[rare - 1])
	instance.card_name = card_name
	instance.max_health = card_data[3]
	instance.health_now = card_data[3]
	instance.work_value = card_data[4]
	#for i in range(rare + 1, 7):
		#if randf() < 1/float(i + 1) and i == rare + 1:
			#rare += 1
	for i in range(instance.star + randi_range(0, 2) + int(rare / 3)):
		add_function(instance)
	write_info(instance)
	return instance

func merge_card() -> void:
	pass

func change_card(card_instance:Node2D, new_card:String) -> void:
	var card_data = CardDict.CardDict[new_card]
	var rare = card_data[1]
	card_instance.get_node("BackGround/Unit").set_texture(card_data[0])
	card_instance.get_node("BackGround").set_texture(CardDict.tile_bg_pic[rare - 1])
	card_instance.card_name = new_card
	write_info(card_instance)

func load_card() -> void:
	pass

func save_card() -> void:
	pass

# ===================================================

func add_function(instance:Node2D) -> void:
	var special_function = CardFunction.SpecialFunction.get(instance.card_name,[])
	if special_function and randf() > 0.5:
		instance.all_function.append(special_function.pick_random())
	else:
		instance.all_function.append(CardFunction.TileFunction.pick_random())

func write_info(instance) -> void:
	instance.info = "%s\n" % [instance.card_name,]
	#self.info += "血量：%d/%d      " % [health_now, max_health]
	#self.info += "工作进度：%d/%d\n" % [work_value_now, work_value]
	instance.info += "--------------------\n额外技能：\n"
	for tmp_function in instance.all_function:
		instance.info += tmp_function[-1] + "\n"
