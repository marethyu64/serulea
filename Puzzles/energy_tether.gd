extends StaticBody2D

class_name energy_tether

signal shit

@export var group = 0
@export var tethers = 0

func _physics_process(delta: float) -> void:
	$Label.text = str(group)


func _on_shit() -> void:
	group = 1
	await get_tree().create_timer(1.0).timeout
	print(group)
