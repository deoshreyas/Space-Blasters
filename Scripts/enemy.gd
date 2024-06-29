extends Area2D
class_name Enemy

@export var speed = 90.0
@export var hp = 2
@export var points = 10

signal killed(points)
signal hit

func _physics_process(delta):
	global_position.y += speed * delta 

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func die():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.die()
		die()

func take_damage(amount):
	hp -= amount
	hit.emit()
	if hp <= 0:
		die()
		killed.emit(points)
