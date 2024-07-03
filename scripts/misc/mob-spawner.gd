extends Node2D

@onready var sprite_spawner: Sprite2D = $Sprite2D

@export var creatures: Array[PackedScene]

@export var SPAWN_COOLDOWN: float

var spawn_cooldown: float = 0.0


func _process(delta):
	if !GameManager.game_over:
		spawn(delta)
	
func spawn(delta):
	spawn_cooldown -= delta
	if spawn_cooldown > 0:
		return
	spawn_cooldown = SPAWN_COOLDOWN
	
	var enemy = creatures[randi_range(0, creatures.size()-1)].instantiate()
	enemy.position = position
	get_parent().add_child(enemy)
