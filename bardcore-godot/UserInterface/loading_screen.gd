extends CanvasLayer
class_name LoadingScreen

@onready var time_label: Label = $Control/Control/Time
@onready var days_label: Label = $Control/Control/Days
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("reveal")

func populate_labels(time):
	time_label.text = str(snapped(time, 1))
	days_label.text = str(GameManager.convert_flee_time(time))

func return_to_village():
	get_tree().change_scene_to_packed(load("uid://cr1ydxfa4aiik"))
	queue_free()
