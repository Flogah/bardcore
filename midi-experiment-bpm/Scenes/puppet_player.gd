extends CharacterBody2D

@export var move_speed = 200.0
@export var jump_distance: float = 100.0
@export var jump_height: float = 50.0
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.25

@export var cam_drag: float = 100

var current_jump_time: float = 0.0

@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var camera: Camera2D = $Camera2D

@onready var jump_velocity: float = calculate_jump_velocity(jump_height, jump_time_to_peak)
@onready var up_gravity: float = calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var down_gravity: float = calculate_fall_gravity(jump_height, jump_time_to_descent)
@onready var horizontal_speed: float = calculate_jump_horizontal_velocity(jump_distance, jump_time_to_peak, jump_time_to_descent)

func _ready() -> void:
	camera.global_position = global_position  + Vector2(0,-100)

func _physics_process(delta: float) -> void:
	if !is_on_floor() and current_jump_time > 0.0:
		current_jump_time -= delta
		#print(current_jump_time)
	if current_jump_time < 0.0:
		if velocity.y < 0.0:
			velocity.y = 0.0
			current_jump_time = 0.0
	
	# Add the gravity.
	if velocity.y <= 0.0:
		velocity.y += up_gravity * delta
	else:
		velocity.y += down_gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("puppet_left", "puppet_right")
	
	if is_on_floor():
		if direction > 0:
			player_sprite.flip_h = false
			player_sprite.play("walk")
		elif direction < 0:
			player_sprite.flip_h = true
			player_sprite.play("walk")
		else:
			player_sprite.play("idle")
	else:
		player_sprite.play("jump")
	
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	
	# Handle jump.
	if Input.is_action_just_pressed("puppet_jump") and is_on_floor():
		velocity.y = jump_velocity
		velocity.x = sign(direction) * horizontal_speed
		current_jump_time = jump_time_to_peak
	if Input.is_action_just_released("puppet_jump"):
		current_jump_time = -1.0
	
	
	move_and_slide()
	drag_camera(delta)

# from GDquest
# height should work in pixels for 2D and meters in 3D
func calculate_jump_velocity(height: float, time_to_peak: float) -> float:
	return (-2.0 * height) / time_to_peak

# makes it easier to control feel of the jump, mario style
func calculate_jump_gravity(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)

func calculate_fall_gravity(height: float, time_to_descent: float) -> float:
	return (2.0 * height) / pow(time_to_descent, 2.0)

func calculate_jump_horizontal_velocity(distance: float, time_to_peak: float, time_to_descent: float) -> float:
	return distance / (time_to_peak + time_to_descent)

func drag_camera(delta: float) -> void:
	var target: Vector2 = global_position 
	# Abstand Kamera -> Ziel
	var offset: Vector2 = target - camera.global_position
	var distance: float = offset.length()
	# Deadzone
	if distance > cam_drag:
		
		# Nur den Teil bewegen der außerhalb der Deadzone liegt
		var excess_distance: float = distance - cam_drag
		
		# Geschwindigkeit skaliert mit Entfernung
		var speed: float = excess_distance * 6.0
		
		# Smooth movement
		camera.global_position = camera.global_position.lerp(
			target - offset.normalized() * cam_drag,
			speed * delta
		)
	# Sicherheitsgrenze:
	# Spieler darf beim Fallen niemals unter den Bildschirmrand verschwinden
	if camera.global_position.y > target.y -100:
		camera.global_position.y = target.y -100
		
