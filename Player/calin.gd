extends CharacterBody2D

const SPEED = 300.0

@export var active = false
@export var follow = false

@onready var lotus: CharacterBody2D = $"../Lotus"

var follow_distance = 150

func _physics_process(delta: float) -> void:
	if active: 
		handle_movement()
	elif follow:
		handle_follow()
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func handle_movement():
	var horizontal_direction := Input.get_axis("Left", "Right")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var vertical_direction := Input.get_axis("Up", "Down")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	

func handle_follow():
	if global_position.distance_to(lotus.global_position) > follow_distance:
		var direction = (lotus.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
