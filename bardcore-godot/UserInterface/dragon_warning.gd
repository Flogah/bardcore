extends Control

@onready var timer: Timer = $BlinkTimer
@onready var life_timer: Timer = $LifeTimer

func _ready() -> void:
	timer.timeout.connect(blink)
	life_timer.timeout.connect(queue_free)

func blink():
	if visible:
		hide()
	else:
		show()
