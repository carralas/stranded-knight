extends Node2D

@export var game_over_ui_prefab: PackedScene

func _ready():
	GameManager.on_game_over.connect(game_over)

func game_over():
	var game_over_ui = game_over_ui_prefab.instantiate()
	add_child(game_over_ui)
