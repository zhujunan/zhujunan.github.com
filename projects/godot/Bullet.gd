extends RigidBody2D

var target : CharacterBody2D
var target_group : String
var damage : int
var speed : int
var range : int

# ["health","speed","attack","attack_range","explode_range","texture"]

func _ready():
	pass

func _physics_process(delta: float):
	pass

func init_bullet(bullet_type : String) -> void:
	var direction = (target.global_position - global_position).normalized()
	linear_velocity = direction * speed
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("Target"):
		body.call_deferred("take_damage", damage)
		queue_free()
