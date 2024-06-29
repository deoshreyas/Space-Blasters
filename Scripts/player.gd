extends CharacterBody2D
class_name Player

@onready var muzzle = $Muzzle

signal laser_shot(laser_scene, location)

const SPEED = 100.0

var laser = preload("res://Scenes/laser.tscn")

var shoot_cooldown = false 

func _process(delta):
	if Input.is_action_pressed("shoot_btn"):
		if not shoot_cooldown:
			shoot_cooldown = true 
			shoot()
			await get_tree().create_timer(0.25).timeout
			shoot_cooldown = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("btn_left", "btn_right"), Input.get_axis("btn_up", "btn_down"))
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()

func shoot():
	laser_shot.emit(laser, muzzle.global_position)

func die():
	queue_free()
