extends Node2D

@onready var pickup_area: Area2D = $PickupArea

@export var HEAL_AMOUNT: int

func _ready():
	pickup_area.body_entered.connect(on_body_entered)

func on_body_entered(body):
	if body.is_in_group('player'):
		var player: Player = body
		player.heal(HEAL_AMOUNT)
		
		queue_free()
