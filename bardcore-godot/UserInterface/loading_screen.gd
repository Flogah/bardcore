extends CanvasLayer
class_name LoadingScreen

@onready var time_label: Label = $Control/Control/Time
@onready var days_label: Label = $Control/Control/Days
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("reveal")

func populate_labels(rooms):
	time_label.text = str(rooms-1)
	days_label.text = str(GameManager.convert_flee_time(rooms))

func return_to_village():
	MapManager.load_home()
	queue_free()
