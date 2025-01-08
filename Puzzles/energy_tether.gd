extends StaticBody2D

const maxrange = 5000

@export var shoot : bool = false
@export var input : bool = false #Is the tether tethered by another tether?
@export var output : bool = false #Is the tether outputting an energy tether?

var mouse_inside = false
var click_activated = false

@onready var tether_manager = get_parent()

@onready var collision: CollisionShape2D = $Line2D/Area2D/CollisionShape2D
@onready var tether_detection: Area2D = $TetherDetection

func _process(delta):
	if Input.is_action_just_pressed("Left Click") and mouse_inside and output == false:
		shoot = true
	if Input.is_action_just_released("Left Click") and output == false:
		if shoot: shoot = false	
	handle_tether()

func _on_mouse_entered() -> void: mouse_inside = true
func _on_mouse_exited() -> void: mouse_inside = false

func handle_tether():
	if output == false and not tether_manager.puzzle_completed:
		if shoot == true:
			collision.shape.b = $Line2D.points[1]
			$Line2D.visible = true
			$TetherLead.visible = true
			var mouse_position = get_local_mouse_position()
			$RayCast2D.target_position = mouse_position
			if $RayCast2D.is_colliding():
				$TetherLead.global_position = $RayCast2D.get_collision_point()
				$Line2D.set_point_position(1,$Line2D.to_local($TetherLead.global_position))
			else:
				$TetherLead.global_position = $RayCast2D.to_global($RayCast2D.target_position)
				$Line2D.points[1] = $Line2D.to_local($TetherLead.global_position)
		else:
			collision.shape.b = Vector2.ZERO
			collision.disabled = true
			$Line2D.visible = false
			$TetherLead.visible = false
			$Line2D.set_point_position(1,Vector2.ZERO)
			$RayCast2D.target_position = Vector2.ZERO



func _on_tether_lead_area_entered(area: Area2D) -> void:
	if area.name == "TetherDetection" and area != tether_detection:
		tether_manager.tether_request.emit(self,area.get_parent())
