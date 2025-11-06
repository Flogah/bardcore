extends State
class_name AttackLine

const ATTACK_LINE_AREA = preload("uid://bgjsdlwnmpwgj")

@export var attack_spawn: Node3D
@export var place_sound: AudioStreamPlayer3D
@export var attack_sound: AudioStreamPlayer3D
var attack_cooldown_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	if !attack_cooldown_timer:
		print("No cooldown timer found. Creating new timer.")
		attack_cooldown_timer = Timer.new()
		add_child(attack_cooldown_timer)
		attack_cooldown_timer.one_shot = true
		attack_cooldown_timer.wait_time = 1.0
	  
	if !attack_cooldown_timer.is_stopped():
		#print("Attack is still on cooldown. Time left: " + str(attack_cooldown_timer.time_left))
		finished.emit("Idle")
		return
	
	attack_cooldown_timer.start(owner.weak_attack_cooldown)
	var attackArea = ATTACK_LINE_AREA.instantiate()
	attackArea.global_position = attack_spawn.global_position
	MapManager.current_map.add_child(attackArea)
	attackArea.rotation = attack_spawn.global_rotation
	place_sound.play()
	
	finished.emit("Idle")
