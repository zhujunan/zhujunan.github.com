var turn_num : int = 0
var enemy_create_list
var enemy_guerrilla_num : int = 5
var enemy_guerrilla_interval : float = 1
var enemy_wave_interval : int = 10

func _on_create_enemy_timeout() -> void:
	var random_index = randi() % enemy_borntile.size()
	var enemy_nest = enemy_borntile[random_index]
	var random_unit_index = randi() % enemy_create_list.size()
	create_unit(enemy_nest,enemy_create_list[random_unit_index], "Enemy")
	
	#if enemy_wave_interval > 0:
		#enemy_wave_interval -= 1
	#else:
		#enemy_wave_interval = 10
		#var enemy_scale = enemy_create_list.pop(0)
		#if enemy_scale == 1:
			#pass
		#else:
			#for i in range(enemy_borntile.size()):
				#create_unit(enemy_nest, "Enemy")

func start_turn() -> void:
	turn_num += 1
	enemy_guerrilla_num += 1
	var enemy_max_value = 10 * turn_num + 50
	enemy_create_list = []
	
	for one_unit in GameData.UnitInfo:
		if GameData.UnitInfo[one_unit][1][0] < enemy_max_value:
			enemy_create_list.append(GameData.UnitInfo[one_unit][0])
	
	enemy_guerrilla_interval = 1
	## 每3轮增加1波次，每10轮增加1总攻
	#var turn_wave_num = int(turn_num / 3) + 1
	#for i in range(turn_wave_num):
		#enemy_create_list.append(i)
	#var turn_massive_num : int = int(turn_num / 10) + 1
	#if turn_massive_num > 0:
		#var interval = ceil(turn_wave_num/turn_massive_num)
		#for i in range(interval):
			#enemy_create_list[i+1] = 2
			#enemy_create_list[-1] = 2

	$CanvasLayer/Shop.visible = false
	$CreateEnemy.wait_time = enemy_guerrilla_interval
	$CreateEnemy.start()
