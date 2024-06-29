extends Node2D

var high_score = 0

var score:
	set(value):
		score = value
		hud.score = score 

const SCROLL_SPEED = 100

@export var enemy_scenes: Array[PackedScene] = []

@onready var player = $PlayerShip
@onready var spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
@onready var timer = $EnemySpawnTimer
@onready var hud = $UILayer/HUD
@onready var game_over_screen = $UILayer/GameOverScreen
@onready var parallax = $ParallaxBackground

@onready var laser_sound = $SFX/Laser
@onready var hit_sound = $SFX/Hit
@onready var explode_sound = $SFX/Explode

func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0 
		save_game()
	score = 0
	player.global_position = spawn_pos.global_position
	player.player_killed.connect(_on_player_killed)

func _process(delta):
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
	parallax.scroll_offset.y += delta * SCROLL_SPEED
	if parallax.scroll_offset.y > 320:
		parallax.scroll_offset.y = 0 

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

func _on_player_ship_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	laser_sound.play()

func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(10, 180), -50)
	enemy.killed.connect(_on_enemy_killed)
	enemy.hit.connect(_on_enemy_hit)
	enemy_container.add_child(enemy)

func _on_enemy_killed(points):
	score += points
	if score>high_score:
		high_score = score 
	
func _on_player_killed():
	explode_sound.play()
	game_over_screen.set_score(score)
	game_over_screen.set_hi_score(high_score)
	save_game()
	await get_tree().create_timer(1.0).timeout
	game_over_screen.visible = true

func _on_enemy_hit():
	hit_sound.play()
