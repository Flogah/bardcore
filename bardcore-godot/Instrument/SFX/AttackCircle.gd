extends State
class_name AttackCircle

const ATTACK_CIRCLE_AREA = preload("uid://bivf4jcutmgdo")

@export var attack_spawn: Node3D
@export var place_sound: AudioStreamPlayer3D
var attack_cooldown_timer: Timer
var attackArea

func enter(previous_state_path: String, data := {}) -> void:
	if !attack_cooldown_timer:
		setup_cd()
	  
	if !attack_cooldown_timer.is_stopped():
		#print("Attack is still on cooldown. Time left: " + str(attack_cooldown_timer.time_left))
		finished.emit("Idle")
		return
	
	attack_cooldown_timer.start(1.0)
	#attackArea.global_position = attack_spawn.global_position
	attackArea = ATTACK_CIRCLE_AREA.instantiate()
	var scale_mult: float = owner.get_parent().stat_comp.get_stat(stat_component.stat_id.ANGLE) + owner.get_parent().stat_comp.get_stat(stat_component.stat_id.RANGE) * 0.65
	attackArea.scale.x *= scale_mult
	attackArea.scale.z *= scale_mult 
	var effect: hit_effect = hit_effect.new()
	effect.amount = owner.get_parent().stat_comp.get_stat(stat_component.stat_id.OUT_DAMAGE)
	effect.type = effect.effect_type.ATTACK
	attackArea.get_child(0).interaction_effect = effect
	MapManager.current_map.add_child(attackArea)
	setup_attack_area()
	
	finished.emit("Idle")
	#place_sound.play()

func setup_attack_area():
	attackArea.global_position = attack_spawn.global_position
	attackArea.rotation = attack_spawn.global_rotation
	attackArea.set_color(owner.player_num)
	await get_tree().create_timer(.01).timeout
	attackArea.activate()

func setup_cd():
	print("No cooldown timer found. Creating new timer.")
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.wait_time = 1.5
