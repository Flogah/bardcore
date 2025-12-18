class_name InputHint
extends Control

@onready var label: RichTextLabel = $InputHint/Label

func set_hint(pos:Vector2 = Vector2(0.0,0.0), text:String = "No Text", input_required:bool = false):
	pos.x -= size.x/2
	pos.y += 20
	position = pos
	
	
	if input_required: text += "\n Interaktion " + get_interact_image("x")
	label.text = text

func get_interact_image(input) -> String:
	# should be built up to support all kinds of controllers
	return "[img=16x16]res://Textures/UI/Input/xbox/" + input + ".png[/img]"
