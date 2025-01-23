extends StaticBody2D

class_name energy_tether

@export var group = 0
@export var tethers = 0

@export var tether_line_1 : Node2D
@export var tether_line_2 : Node2D

func _physics_process(delta: float) -> void:
	$Label.text = str(group)
