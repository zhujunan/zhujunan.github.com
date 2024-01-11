func _on_create_enemy_timeout() -> void:
	var random_index = randi() % enemy_borntile.size()
	var enemy_nest = enemy_borntile[random_index]
	create_unit(enemy_nest, "Enemy")


func start_turn() -> void:
	turn_num += 1
	# 每3波，增加1轮波次，每10轮增加1总攻
	turn_wave_num = int(turn_num / 3) + 1
	var turn_massive_num : int = int(turn_num / 10)
	var turn_massive_interval : int = int()
	
	turn_wave_interval = 1	
	turn_massive_index = range(1, turn_wave_num, turn_massive_interval)
	
	$CanvasLayer/Shop.visible = false
	$CreateEnemy.start()
