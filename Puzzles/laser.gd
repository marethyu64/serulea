extends Node2D

const maxrange = 5000

var shoot = true
@onready var collision = $Line2D/DetectionArea/CollisionShape2D
@onready var reference: Sprite2D = $Reference
@onready var line_2d: Line2D = $Line2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready():
	pass

func _process(delta):
	var mouse_position = get_local_mouse_position()
	var max_cast_to = (global_position + Vector2(100,0)).normalized() * maxrange
	ray_cast_2d.target_position = max_cast_to
	if ray_cast_2d.is_colliding():
		reference.global_position = ray_cast_2d.get_collision_point()
		line_2d.set_point_position(1,line_2d.to_local(reference.global_position))
	else:
		reference.global_position = ray_cast_2d.target_position
		line_2d.points[1] = reference.global_position
	if shoot == true:
		collision.shape.b = line_2d.points[1]
		line_2d.visible = true
	else:
		collision.shape.b = Vector2.ZERO
		collision.disabled = true
		line_2d.visible = false
