extends Node2D

var score:
	set(value):
		score = value
		hud.score = score 

@export var enemy_scenes: Array[PackedScene] = []

@onready var player = $PlayerShip
@onready var spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
@onready var timer = $EnemySpawnTimer
@onready var hud = $UILayer/HUD

func _ready():
	score = 0
	player.global_position = spawn_pos.global_position

func _on_player_ship_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(10, 180), -50)
	enemy.killed.connect(_on_enemy_killed)
	enemy_container.add_child(enemy)

func _on_enemy_killed(points):
	score += points
