extends Area2D

@export var SPEED = -250.0

func _physics_process(delta):
	global_position.y += SPEED * delta 

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()