extends AnimatableBody2D

var is_down: bool = true


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_platform"):
		if is_down == true:
			move_up()
		else: 
			move_down()

func move_up():
	animation_player.play("platformUp")
	is_down = false
	
func move_down():
	animation_player.play_backwards("platformUp")
	is_down = true
