extends CharacterBody2D

@export var move_vector : Vector2 = Vector2.ZERO

func _physics_process(delta):
	velocity = move_vector * delta
	move_and_slide()
