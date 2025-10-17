extends Node3D
class_name portal

@onready var spawn_center: Node3D = $SpawnCenter
@onready var enter_area: Area3D = $EnterArea
@onready var preview: MeshInstance3D = $SpawnCenter/Preview

@onready var gate: Node3D = $Gate
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gate_blocker: CollisionShape3D = $GateBlocker/CollisionShape3D

@export var entrance : bool = false

var connected_exit : portal
var locked : bool = false

func _ready() -> void:
	preview.hide()
	gate_blocker.disabled = true

func _on_player_entered(body: Node3D) -> void:
	if locked:
		pass

func lock():
	if locked:
		return
	gate.visible = true
	animation_player.play("close")
	locked = true
	gate_blocker.disabled = false

func unlock():
	if !locked:
		return
	animation_player.play("open")
	locked = false
	gate_blocker.disabled = true
