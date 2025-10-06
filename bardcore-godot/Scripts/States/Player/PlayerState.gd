class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const DASHING = "Dashing"

var player: Player
var input

func _ready() -> void:
	await owner.ready
	player = owner as Player
	input = player.input
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
