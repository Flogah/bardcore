extends State
class_name AttackLine

const ATTACK_LINE_AREA = preload("uid://bgjsdlwnmpwgj")

@export var attack_spawn: Node3D
@export var place_sound: AudioStreamPlayer3D
var attack_cooldown_timer: Timer
var attackArea

func enter(previous_state_path: String, data := {}) -> void:
	if !attack_cooldown_timer:
		setup_cd_timer()
	  
	if !attack_cooldown_timer.is_stopped():
		finished.emit("Idle")
		return
	
	attack_cooldown_timer.start(1.0)
	#attackArea.global_position = attack_spawn.global_position
	attackArea = ATTACK_LINE_AREA.instantiate()
	MapManager.current_map.add_child(attackArea)
	setup_attack_area()
	
	finished.emit("Idle")

func setup_attack_area():
	attackArea.global_position = attack_spawn.global_position
	attackArea.rotation = attack_spawn.global_rotation
	attackArea.set_color(owner.player_num)
	await get_tree().create_timer(.01).timeout
	attackArea.activate()

#func _input(event):
	#if event.is_action_released("attack_line"):
	
func setup_cd_timer():
	print("No cooldown timer found. Creating new timer.")
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.wait_time = 3.0
