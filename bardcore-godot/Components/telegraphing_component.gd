extends Node3D
class_name telegraphing_component

var e_type = hit_effect.effect_type

func display_number(value: int, type: hit_effect.effect_type):
	var num: Label3D = Label3D.new()
	var color = Color.DEEP_PINK
	
	if type == e_type.ATTACK:
		color = Color.WHITE_SMOKE
	elif type == e_type.HEAL:
		color = Color.GREEN_YELLOW
	
	num.text = str(value)
	num.modulate = color
	num.outline_modulate = Color.BLACK
	num.font = preload("res://addons/Kenney_Fonts/Kenney High Square.ttf")
	num.font_size = 250
	num.outline_size = 4
	num.pixel_size = 0.005
	num.width = 500.0
	num.scale = Vector3.ONE
	num.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	
	MapManager.current_map.add_child(num)
	num.global_position = global_position
	num.position.x += randf_range(-.2,.2)
	num.position.y += randf_range(-.2,.2)
	
	if is_inside_tree():
		var tween: Tween = get_tree().create_tween()
		
		tween.set_parallel(true)
		tween.tween_property(num, "position:y", num.position.y - -2, 0.25).set_ease(Tween.EASE_OUT)
		tween.tween_property(num, "position:y", num.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(0.25)
		tween.tween_property(num, "scale", Vector3.ZERO, .25).set_delay(0.5).set_ease(Tween.EASE_IN)
		
		tween.finished.connect(num.queue_free)
	else: num.queue_free()
