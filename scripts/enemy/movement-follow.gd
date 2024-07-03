extends Node

var enemy: Enemy
var sprite: AnimatedSprite2D

@export var SPEED: float
@export var ACCELERATION: float

var input_vector: Vector2 = Vector2(0,0)

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node('AnimatedSprite2D')

func _process(delta):
	var player_position: Vector2 = GameManager.player_position
	input_vector = (player_position - enemy.position).normalized()
	if GameManager.game_over:
		input_vector *= -1
	
	move_animation()

func _physics_process(delta):
	move()

func move():
	var target_velocity = input_vector * SPEED
	
	enemy.velocity = lerp(enemy.velocity, target_velocity, ACCELERATION)
	enemy.move_and_slide()
	
func move_animation():
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
