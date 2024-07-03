extends CanvasLayer

var restart_delay: float = 10.

func _process(delta):
	restart_delay -= delta
	if restart_delay <= 0:
		restart()

func restart():
	get_tree().reload_current_scene()
	GameManager.reset()
