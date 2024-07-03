class_name Enemy
extends Node2D

@onready var damage_marker: Marker2D = $DamageMarker

@export var death_prefab: PackedScene
@export var damage_tooltip_prefab: PackedScene

@export var HP: int
@export var DAMAGE: int
@export var GOLD: int

func _process(delta):
	if HP <= 0:
		death()

func take_damage(amount):
	HP -= amount
	
	var damage_tooltip = damage_tooltip_prefab.instantiate()
	damage_tooltip.value = amount
	damage_tooltip.position = damage_marker.global_position
	get_parent().add_child(damage_tooltip)
	
	damage_animation()

func damage_animation():
	var tween = create_tween()
	modulate = Color.RED
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, 'modulate', Color.WHITE, 0.25)

func death():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	GameManager.gold += GOLD
	queue_free()
