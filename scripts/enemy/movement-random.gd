extends Node

var enemy: Enemy
var sprite: AnimatedSprite2D

@export var SPEED: float
@export var ACCELERATION: float
@export var DIRECTION_COOLDOWN: float

var input_vector: Vector2 = Vector2(randf_range(-1,1),randf_range(-1,1))
var direction_cooldown: float = 1.5

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node('AnimatedSprite2D')

func _process(delta):
	move_animation()

func _physics_process(delta):
	move(delta)

func move(delta):
	direction_cooldown -= delta
	if direction_cooldown < 0:
		input_vector = Vector2(randf_range(-1,1),randf_range(-1,1))
		direction_cooldown = DIRECTION_COOLDOWN
	
	var target_velocity = input_vector * SPEED
	
	enemy.velocity = lerp(enemy.velocity, target_velocity, ACCELERATION)
	enemy.move_and_slide()
	
func move_animation():
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
