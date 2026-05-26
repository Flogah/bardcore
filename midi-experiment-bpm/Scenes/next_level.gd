extends Node2D


var game_over:bool = false

@export var end_portal:EndPortal
@export var game_over_ui:CanvasLayer
@export var player:CharacterBody2D

func _ready() -> void:
	end_portal.end_reached.connect(_on_game_over_reached)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		manual_reset()

func _process(_delta: float) -> void:
	if player.global_position.y > 800:
		manual_reset()

func _on_game_over_reached():
	game_over = true
	game_over_ui.show()
	get_tree().paused = true

func manual_reset():
	get_tree().reload_current_scene()
