extends Area2D

@export var enabled : bool = false
@export var destination : PackedScene
@export var direction : String

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Lotus":
		if body.get_parent().follow_mode == true:
			TransitionScreen.transition(direction)
			await TransitionScreen.on_transition_finished
			if destination != null: get_tree().change_scene_to_packed(destination)
