extends Area2D

@export var enabled : bool = false
@export var scene : PackedScene
@export var direction : String

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Lotus":
		if body.get_parent().follow_mode == true:
			Navigation.change_scene(scene, direction)
