extends Node2D

var value: int = 0

func _ready():
	$Node2D/Label.text = str(value)
