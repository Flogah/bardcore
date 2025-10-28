extends State
class_name AttackLine

const ATTACK_LINE_AREA = preload("uid://bgjsdlwnmpwgj")
@export var attack_spawn: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	var attackArea = ATTACK_LINE_AREA.instantiate()
	attackArea.global_position = attack_spawn.global_position
	get_tree().current_scene.add_child(attackArea)
	attackArea.rotation = attack_spawn.rotation
	
	
	finished.emit("Idle")
