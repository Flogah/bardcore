class_name EndPortal
extends Area2D

signal end_reached
@onready var game_over_ui: CanvasLayer = %GameOverUI

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("playerpuppet"):
		return
	
	end_reached.emit()
	
func _on_end_reached():
	get_tree().paused = true
	game_over_ui.show()
