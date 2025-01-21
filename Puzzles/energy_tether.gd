extends StaticBody2D

class_name energy_tether

@export var group = 0
@export var tethers = 0

func _physics_process(delta: float) -> void:
	$Label.text = str(group)
