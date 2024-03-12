extends Node2D

const gridColor : Color = Color(1, 1, 1, 0.5)  # 网格线的颜色

func _ready() -> void:
	pass

func _draw():
	# 绘制垂直网格线
	var x = 0
	var border_x = get_parent().grid_num.x * get_parent().grid_size.x
	var border_y = get_parent().grid_num.y * get_parent().grid_size.y
	while x <= border_x:
		draw_line(Vector2(x, 0), Vector2(x, border_y), gridColor)
		x += get_parent().grid_size.x

	# 绘制水平网格线
	var y = 0
	while y <= border_y:
		draw_line(Vector2(0, y), Vector2(border_x, y), gridColor)
		y += get_parent().grid_size.y
