extends Node

var Bullet : PackedScene = preload("res://Scenes/Bullets.tscn")

# ["health","armor","attack","attack_interval","attack_range","fire_effect","bullet"],
var unit_data = {
				"Bazooka": [80, 1, 1, 3, 200,"Rifle","Missile"]
				}

# ["health","speed","attack","attack_range","explode_range","texture"]
var bullet_data = {
				"Missile": [30, 10, 100, 200, 20,"rocket1"],
				"Bullet": [-1, 10, 10, 200, -1,"Rifle"]
				}
