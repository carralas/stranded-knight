extends CanvasLayer

@onready var label_timer: Label = $Panel/LabelTimer
@onready var label_gold: Label = $Panel/LabelGold

var timer: float = 0.0
var kills: int = 0
var gold: float = 0.0

func _process(delta):
	if !GameManager.game_over:
		timer += delta
	var timer_seconds: int = floori(timer)
	
	var minutes: int = timer_seconds / 60
	var seconds: int = timer_seconds % 60
	label_timer.text = '%02d:%02d' % [minutes, seconds]
	
	label_gold.text = str(GameManager.gold)
