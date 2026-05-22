extends Control

@onready var timer: Timer = %Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UserInterface.hide()
	timer.timeout.connect(_on_timeout)
	timer.start()

func _on_timeout():
	UserInterface.show()
	get_tree().change_scene_to_packed(load("uid://b27ykus1hcepg"))
