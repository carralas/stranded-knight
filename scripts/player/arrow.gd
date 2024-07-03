extends CharacterBody2D

@onready var contact_area: Area2D = $ContactArea

var input_vector: Vector2 = Vector2(randf_range(-1,1),randf_range(-1,1))

@export var SPEED: float = 750.0
@export var ACCELERATION: float = 0.125
@export var DAMAGE_AMOUNT: int = 2.0

var timer: float = 0.5

func _ready():
	contact_area.body_entered.connect(on_body_entered)

func _process(delta):
	despawn(delta)

func _physics_process(delta):
	move()

func on_body_entered(body):
	if body.is_in_group('target'):
		var enemy: Enemy = body
		enemy.take_damage(DAMAGE_AMOUNT)
		
		queue_free()

func move():
	var target_velocity = input_vector.normalized() * SPEED
	velocity = lerp(velocity, target_velocity, ACCELERATION)
	rotation = Vector2.UP.angle_to(velocity) + 270*PI/180
	
	move_and_slide()

func despawn(delta):
	timer -= delta
	if timer > 0:
		return
	
	queue_free()
