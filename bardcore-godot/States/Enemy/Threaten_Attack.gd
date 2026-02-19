extends State
class_name ThreatenAttack

@export var animation_player: AnimationPlayer
@export var threatening_time: float = .2

func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play("threaten")
	
	var threat_timer = Timer.new()
	threat_timer.timeout.connect(end_threat)
	threat_timer.one_shot = true
	threat_timer.autostart = false
	add_child(threat_timer)
	threat_timer.start(threatening_time)

func end_threat():
	animation_player.stop()
	
	if owner.dead:
		finished.emit("EnemyDead")
	else:
		finished.emit("EnemyAttack")
