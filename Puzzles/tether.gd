extends Node2D

signal tether_complete

@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $Line2D/Area2D/CollisionShape2D

@export var tether1 : StaticBody2D
@export var tether2 : StaticBody2D

var mouse_entered = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Left Click") and mouse_entered:
		sever_tether()

func _on_area_2d_mouse_entered() -> void: mouse_entered = true
func _on_area_2d_mouse_exited() -> void: mouse_entered = false

func sever_tether():
	tether1.tethers -= 1
	tether2.tethers -= 1
	remove_reference_to_tethers()
	queue_free()

func _on_tether_complete() -> void:
	add_collision()
	add_reference_to_tethers()
	

func add_collision():
	var start = line_2d.points[0]
	var end = line_2d.points[1]
	var segment = end - start
	
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(segment.length() / 2, line_2d.width / 2)
	collision_shape_2d.shape = rect_shape
	collision_shape_2d.position = start + segment / 2
	collision_shape_2d.rotation = segment.angle()

func add_reference_to_tethers():
	if tether1.tether_line_1 == null:
		tether1.tether_line_1 = self
	else:
		tether1.tether_line_2 = self
	if tether2.tether_line_1 == null:
		tether2.tether_line_1 = self
	else:
		tether2.tether_line_2 = self

func remove_reference_to_tethers():
	if tether1.tether_line_1 == self:
		tether1.tether_line_1 = null
	else:
		tether1.tether_line_2 = null
	if tether2.tether_line_1 == self:
		tether2.tether_line_1 = null
	else:
		tether2.tether_line_2 = null
