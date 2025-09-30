extends State
class_name WeakAttack

@export var soundVFX: PackedScene
@export var attack_sound: AudioStreamPlayer3D
@export var vfx_spawn: Node3D
@export var hitbox: Area3D

var attack_cooldown_timer: Timer

func enter(previous_state_path: String, data := {}) -> void:
	if !attack_cooldown_timer:
		print("No cooldown timer found. Creating new timer.")
		attack_cooldown_timer = Timer.new()
		add_child(attack_cooldown_timer)
		attack_cooldown_timer.one_shot = true
	
	if !attack_cooldown_timer.is_stopped():
		#print("Attack is still on cooldown. Time left: " + str(attack_cooldown_timer.time_left))
		finished.emit("Idle")
		return
	
	attack_cooldown_timer.start(owner.weak_attack_cooldown)
	
	attack_sound.play()
	var new_vfx = soundVFX.instantiate()
	vfx_spawn.add_child(new_vfx)
	new_vfx.global_position = vfx_spawn.global_position
	
	var hit_bodies = hitbox.get_overlapping_bodies()
	var hit_enemies : Array
	for body in hit_bodies:
		if body.is_in_group("Enemy"):
			hit_enemies.append(body)
	
	for enemy in hit_enemies:
		# push away from owner
		var dir = (enemy.global_position - owner.global_position).normalized()
		# push in view direction
		#var dir = -owner.global_transform.basis.z
		enemy.velocity = dir * 200
		enemy.velocity.y = 3
		enemy.move_and_slide()
	
	finished.emit("Idle")
