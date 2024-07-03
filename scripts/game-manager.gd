extends Node

signal on_game_over

var game_over: bool = false
var kills: int = 0
var gold: float = 0.0
var player_position: Vector2

func end_game():
	if game_over:
		return
	game_over = true
	on_game_over.emit()

func reset():
	game_over = false
	player_position = Vector2(500,500)
	for connection in on_game_over.get_connections():
		on_game_over.disconnect(connection.callable)
