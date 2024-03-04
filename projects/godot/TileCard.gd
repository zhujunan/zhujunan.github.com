extends Card


var work_list = []
var buff_list = []

var rare_pic = [
	preload("res://Card/BackGround/CardFrame01_BackFrame_d.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Green.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Blue.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Purple.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Red.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Yellow.png"),
	]

func _ready() -> void:
	if !self.card_name:
		return
	super._ready()
	init_work()
	init_info()
	$BackGround.set_texture(rare_pic[self.rare - 1])
	$WorkTimer.start()

func get_star() -> void:
	pass

func init_work() -> void:
	var all_work = RecipeDict.ProduceRecipeDict[self.card_name]
	var work_num = self.star
	for tmp_work in all_work:
		if tmp_work[0] > self.rare:
			continue
		if tmp_work[1] < randf():
			continue
		if tmp_work[1] == 1:
			work_num -= 1
		if work_num == 0:
			return
		work_list.append([tmp_work[2], tmp_work[3], tmp_work[4]])

func init_info() -> void:
	self.info = "%s\n--------------------\n" % [self.card_name,]
	for tmp_work in work_list:
		if tmp_work[0]:
			if tmp_work[1]:
				self.info += "每相邻"
			else:
				self.info += "若相邻"
			for i in tmp_work[0]:
				self.info += " %d %s, " % [tmp_work[0][i], i]
		
		for i in tmp_work[2]:
			self.info += "%s + %d\n" % [i, tmp_work[2][i]]

func work() -> void:
	for tmp_work in work_list:
		if tmp_work[0]:
			continue
			if tmp_work[1]:
				self.info += "每相邻"
			else:
				self.info += "若相邻"
			for i in tmp_work[0]:
				self.info += " %d %s, " % [tmp_work[0][i], i]
		
			for i in tmp_work[2]:
				self.info += "%s + %d\n" % [i, tmp_work[2][i]]

		else:
			for i in tmp_work[2]:
				self.world.Inventory[i] = self.world.Inventory.get(i, 0) + tmp_work[2][i]
				var cloned_node = $BackGround/CardUI/ShowProduct/OneProduct.duplicate()
				cloned_node.get_node("Pic").set_texture(load(ItemDict.ItemDict[i]))
				cloned_node.get_node("Num").text = "+ %d" % [tmp_work[2][i],]
				add_child(cloned_node)
				cloned_node.position = Vector2(-100, 30)
				var tween = cloned_node.create_tween()
				tween.tween_property(cloned_node, "position", Vector2(-100,-120), 2.5)
				cloned_node.get_node("Timer").start()
