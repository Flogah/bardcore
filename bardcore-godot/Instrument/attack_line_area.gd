extends Node3D

func _on_triggered() -> void: 
	print("EXPLOSION!")
	queue_free()
