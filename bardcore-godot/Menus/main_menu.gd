extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MapManager.HOMEBASE)
	queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
