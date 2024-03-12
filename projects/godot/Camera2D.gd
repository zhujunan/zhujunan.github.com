extends Camera2D

var movement_speed : int = 5000
var move_vector : Vector2

var pos_up : int
var pos_left : int
var pos_bottom : int
var pos_right : int

func _ready() -> void:
	get_viewport().size_changed.connect(change_camera_rect)
	change_camera_rect()
	
func _process(delta: float) -> void:
	camera_move(delta)
	
func camera_move(delta) -> void:
	move_vector = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		move_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vector.y += 1
	if Input.is_action_pressed("move_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vector.x += 1
	move_vector = move_vector.normalized() * movement_speed
	position.x = clamp(position.x + move_vector.x * delta, pos_left, pos_right)
	position.y = clamp(position.y + move_vector.y * delta, pos_up, pos_bottom)

func camera_zoom(new_zoom : int) -> void:
	if new_zoom == 0:
		zoom.x = 0.3
		zoom.y = 0.3
	else:
		zoom.x = clamp(zoom.x + new_zoom * 0.01, 0.1, 0.5)
		zoom.y = clamp(zoom.y + new_zoom * 0.01, 0.1, 0.5)
		
	change_camera_rect()

func change_camera_rect() -> void:
	pos_up = int(get_viewport_rect().size.y/2/zoom.y)
	pos_left = int(get_viewport_rect().size.x/2/zoom.y)
	pos_right = get_parent().grid_size.x * get_parent().grid_num.x - get_viewport_rect().size.x/2/zoom.x
	pos_bottom = get_parent().grid_size.y * get_parent().grid_num.y - get_viewport_rect().size.y/2/zoom.y
