class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite_player: Sprite2D = $Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var hitbox_area: Area2D = $HitboxArea

@export var death_prefab: PackedScene
@export var skill_arrow_prefab: PackedScene

@export var MAX_HP: int = 25
@export var CURRENT_HP: int = MAX_HP
@export var SPEED: float = 375.0
@export var ACCELERATION: float = 0.25
@export var BASE_DAMAGE: float = 1.0
@export var DAMAGE_MODIFIER: float = 1.0
@export var ATTACK_COOLDOWN: float = 0.5
@export var HITBOX_COOLDOWN: float = 1.0
@export var SKILL_ARROW_COOLDOWN: float = 12.5

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 1.0
var skill_arrow_cooldown: float = 0.0

func _process(delta):
	health_bar.max_value = MAX_HP
	health_bar.value = CURRENT_HP
	
	GameManager.player_position = position
	input_vector = Input.get_vector("move_left","move_right", "move_up", "move_down")
	move_animation()
	
	if Input.is_action_just_pressed('attack'):
		attack_animation()
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
	
	if Input.is_action_just_pressed('skill_arrow'):
		skill_arrow()
	if skill_arrow_cooldown > 0:
		skill_arrow_cooldown -= delta
	
	iframes(delta)

func _physics_process(delta):
	move()

func move():
	var target_velocity = input_vector * SPEED
	if is_attacking:
		target_velocity *= .25
	velocity = lerp(velocity, target_velocity, ACCELERATION)
	
	move_and_slide()

func move_animation():
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	if was_running != is_running and not is_attacking:
		if is_running:
			animation_player.play('run')
		else:
			animation_player.play('idle')
	
	if not is_attacking:
		if input_vector.x > 0:
			sprite_player.flip_h = false
		elif input_vector.x < 0:
			sprite_player.flip_h = true

func attack():
	var target_enemies = attack_area.get_overlapping_bodies()
	
	for body in target_enemies:
		if body.is_in_group('target'):
			var enemy: Enemy = body
			var enemy_direction = (enemy.position - position).normalized()
			var attack_direction: Vector2
			
			if sprite_player.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			
			if enemy_direction.dot(attack_direction) >= 0.375:
				enemy.take_damage(BASE_DAMAGE * DAMAGE_MODIFIER)

func attack_animation():
	if is_attacking:
		return
	
	animation_player.play('attack-side-1')
	is_attacking = true
	attack_cooldown = ATTACK_COOLDOWN

func skill_arrow():
	if skill_arrow_cooldown > 0:
		return
	skill_arrow_cooldown = SKILL_ARROW_COOLDOWN
	
	var skill_arrow_spawner = skill_arrow_prefab.instantiate()
	skill_arrow_spawner.position = position
	get_parent().add_child(skill_arrow_spawner)

func damage(amount):
	if CURRENT_HP <= 0:
		death()
		return
	CURRENT_HP -= amount
	
	damage_animation()

func damage_animation():
	var tween = create_tween()
	modulate = Color.RED
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, 'modulate', Color.WHITE, 0.25)

func iframes(delta):
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0:
		return
	hitbox_cooldown = HITBOX_COOLDOWN
	
	var bodies = hitbox_area.get_overlapping_bodies()

	for body in bodies:
		if body.is_in_group('enemies'):
			var enemy: Enemy = body
			damage(enemy.DAMAGE)

func heal(amount):
	CURRENT_HP += amount
	if CURRENT_HP > MAX_HP:
		CURRENT_HP = MAX_HP
	
	heal_animation()

func heal_animation():
	var tween = create_tween()
	modulate = Color.GREEN
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, 'modulate', Color.WHITE, 0.25)

func death():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	GameManager.end_game()
	queue_free()
