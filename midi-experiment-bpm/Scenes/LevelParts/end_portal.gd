class_name EndPortal
extends Area2D

signal end_reached

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("playerpuppet"):
		return
	_on_end_reached()
	
func _on_end_reached():
	end_reached.emit()
