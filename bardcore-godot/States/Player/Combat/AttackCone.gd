extends State
class_name AttackCone

const ATTACK_CONE_AREA = preload("uid://d0o1tl8lwamf")

@export var attack_spawn: Node3D
@export var place_sound: AudioStreamPlayer3D
var attack_cooldown_timer: Timer
var attackArea

func enter(previous_state_path: String, data := {}) -> void:
	owner.attack_cooldown_timer.timeout.connect(end_attack)
	owner.attack_cooldown_timer.start(owner.weak_attack_cooldown)
	setup_attack_area()

func setup_attack_area():
	attackArea = ATTACK_CONE_AREA.instantiate()
	attackArea.scale.x *= owner.get_parent().stat_comp.get_stat(stat_component.stat_id.ANGLE)
	attackArea.scale.z *= owner.get_parent().stat_comp.get_stat(stat_component.stat_id.RANGE)
	var effect: hit_effect = hit_effect.new()
	effect.amount = owner.get_parent().stat_comp.get_stat(stat_component.stat_id.OUT_DAMAGE)
	effect.type = effect.effect_type.ATTACK
	attackArea.get_child(0).interaction_effect = effect
	MapManager.current_map.add_child(attackArea)
	attackArea.global_position = attack_spawn.global_position
	attackArea.rotation = attack_spawn.global_rotation
	attackArea.set_color(owner.player_num)
	await get_tree().create_timer(.01).timeout
	attackArea.activate()

func end_attack():
	finished.emit("Idle")

func exit():
	owner.attack_cooldown_timer.timeout.disconnect(end_attack)
