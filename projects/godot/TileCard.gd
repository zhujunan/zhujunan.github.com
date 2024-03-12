extends Card

func _ready() -> void:
	if !self.card_name:
		return
	super._ready()
	$BackGround.set_texture(CardDict.tile_bg_pic[self.rare - 1])

func work00() -> void:
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
