class_name InputHint
extends Control

@onready var label: Label = $Label

func set_hint(pos:Vector2 = Vector2(0.0,0.0), text:String = "No Text"):
	position = pos
	label.text = text
