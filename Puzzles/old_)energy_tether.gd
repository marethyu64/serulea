extends Area2D

const maxrange = 5000

@export var shoot = false
@export var tethered = false 
@export var tether_count = 0

var mouse_inside = false
var click_activated = false

@onready var collision: CollisionShape2D = $"../Line2D/Area2D/CollisionShape2D"
@onready var ray_cast_2d: RayCast2D = $"../RayCast2D"
@onready var line_2d: Line2D = $"../Line2D"
@onready var tether_lead: Area2D = $"../TetherLead"

func _process(delta):
	if Input.is_action_just_pressed("Left Click") and mouse_inside and tethered == false:
		shoot = true
	if Input.is_action_just_released("Left Click") and tethered == false:
		if shoot: shoot = false	
	handle_tether()

func _on_mouse_entered() -> void: mouse_inside = true
func _on_mouse_exited() -> void: mouse_inside = false

func handle_tether():
	if tethered == false:
		if shoot == true:
			collision.shape.b = line_2d.points[1]
			line_2d.visible = true
			tether_lead.visible = true
			var mouse_position = get_local_mouse_position()
			ray_cast_2d.target_position = mouse_position
			if ray_cast_2d.is_colliding():
				tether_lead.global_position = ray_cast_2d.get_collision_point()
				line_2d.set_point_position(1,line_2d.to_local(tether_lead.global_position))
			else:
				tether_lead.global_position = ray_cast_2d.to_global(ray_cast_2d.target_position)
				line_2d.points[1] = line_2d.to_local(tether_lead.global_position)
		else:
			collision.shape.b = Vector2.ZERO
			collision.disabled = true
			line_2d.visible = false
			tether_lead.visible = false
			line_2d.set_point_position(1,Vector2.ZERO)
			ray_cast_2d.target_position = Vector2.ZERO

func _on_tether_lead_area_entered(area: Area2D) -> void:
	if area.name == "TetherDetection" and area != self:
		if area.tethered == false:
			tethered = true
			tether_lead.global_position = area.global_position
			line_2d.points[1] = line_2d.to_local(area.global_position)
			area.shoot = true
