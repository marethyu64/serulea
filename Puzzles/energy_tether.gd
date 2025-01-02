extends Area2D

const maxrange = 5000

var shoot = false

@onready var collision: CollisionShape2D = $"../Line2D/Area2D/CollisionShape2D"
@onready var reference: Sprite2D = $"../Reference"
@onready var ray_cast_2d: RayCast2D = $"../RayCast2D"
@onready var line_2d: Line2D = $"../Line2D"

func _process(delta):
	var mouse_position = get_local_mouse_position()
	ray_cast_2d.target_position = mouse_position
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

func _on_mouse_entered() -> void:
	if Input.is_action_pressed("Left Click"):
		shoot = true
