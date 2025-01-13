extends Area2D

@export var enabled : bool = false
@export var scene_file : String
@export var direction : String
@export var spawn_location : String

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Lotus":
		if body.get_parent().follow_mode == true:
			print("Entering ", scene_file)
			Navigation.change_scene(scene_file, direction, spawn_location)
