extends AnimatableBody2D

var is_down: bool = true
var max_move_up: int = 500
var max_move_down: int = 0
var move_speed: int = 20

@onready var start_pos_y: int = int(position.y)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Schnittstelle.up.connect(move_up)
	Schnittstelle.down.connect(move_down)

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("test_platform"):
		#if is_down == true:
			#move_up()
		#else: 
			#move_down()
	pass

func move_up():
	#animation_player.play("platformUp")
	is_down = false
	if position.y > start_pos_y - max_move_up:
		position.y -= move_speed
	print("moving up")
	
func move_down():
	#animation_player.play_backwards("platformUp")
	is_down = true
	if position.y < start_pos_y + max_move_down:
		position.y += move_speed
