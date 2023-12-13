extends Unit

var new_health := 10000
var new_move_speed := 100
var new_armor := 1
var new_defense := 1
var new_addition_damage := 10
var new_ammo_load = null

func _ready() -> void:
	var shape1 = CircleShape2D.new()
	shape1.radius = 500
	$AttackRange.get_node("CollisionShape2D").shape = shape1
	var shape2 = CircleShape2D.new()
	shape2.radius = 50
	$MoveRange.get_node("CollisionShape2D").shape = shape2
	super.init_unit(new_health, new_move_speed, new_armor, new_defense, new_addition_damage)

# color
