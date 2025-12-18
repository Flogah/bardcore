extends Node3D
class_name telegraphing_component

var e_type = hit_effect.effect_type
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

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
	num.font_size = 8
	num.outline_size = 4
	num.pixel_size = 0.005
	num.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	
	owner.owner.add_child(num)
	num.global_position = global_position
	num.position.x += rng.randf_range(-2,2)
	num.position.y += rng.randf_range(-2,2)
	
	var tween: Tween = get_tree().create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(num, "position:y", num.position.y - 24, 0.25).set_ease(Tween.EASE_OUT)
	tween.tween_property(num, "position:y", num.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(num, "scale", Vector3.ZERO, 0.25).set_delay(0.5).set_ease(Tween.EASE_IN)
	
	await tween.finished
	num.queue_free()
