extends Node3D
class_name Map

@export var mapGameState : GameManager.gameState
const DRAGON_ARRIVAL = preload("uid://dlsx2cbhuy1ij")

var game_over:bool = false

func spawn_players():
	pass

func arrive_dragon():
	var dragon = DRAGON_ARRIVAL.instantiate()
	add_child(dragon)
