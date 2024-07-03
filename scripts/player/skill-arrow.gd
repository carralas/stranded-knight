extends Node2D

@export var arrow_prefab: PackedScene

@export var ARROW_VOLUME: int = 100

func _ready():
	spawn_arrows()

func spawn_arrows():
	for k in range(ARROW_VOLUME):
		var arrow = arrow_prefab.instantiate()
		arrow.position = position
		get_parent().add_child(arrow)
	
	queue_free()
