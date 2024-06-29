extends Node2D

@onready var player = $PlayerShip
@onready var spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer

func _ready():
	player.global_position = spawn_pos.global_position

func _on_player_ship_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
