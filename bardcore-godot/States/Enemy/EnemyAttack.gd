extends State
class_name EnemyAttack

@export var animation_player: AnimationPlayer
@export var attack_area: hit_emitter_box

func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play("attack")
	attack_area.hit_check()
	
	var attack_timer = Timer.new()
	attack_timer.timeout.connect(end_attack)
	attack_timer.one_shot = true
	attack_timer.autostart = false
	add_child(attack_timer)
	attack_timer.start(.3)

func end_attack():
	finished.emit("EnemyFollow")

func exit():
	var effect = $"../../Visual/AttackEffect"
	effect.hide()
