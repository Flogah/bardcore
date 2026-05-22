extends Control

@onready var timer: Timer = %Timer
@onready var button_sprite: TextureRect = %ButtonTextureRect

var blink_timer_length:float = 0.5
var blink_timer:float

func _ready() -> void:
	UserInterface.hide()
	reset_blink_timer()
	timer.timeout.connect(_on_timeout)

func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer > blink_timer_length:
		invert_visibility()
		reset_blink_timer()

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		get_viewport().set_input_as_handled()
		timer.start()
		blink_timer_length = 0.1
		reset_blink_timer()

func reset_blink_timer():
	blink_timer = 0.0

func invert_visibility():
	button_sprite.visible = !button_sprite.visible

func _on_timeout():
	UserInterface.show()
	get_tree().change_scene_to_packed(load("uid://cr1ydxfa4aiik"))
