extends Node

@export var direction_exit : String

const SCENE_1_HALLWAY = preload("res://Scenes/Scene 1/scene_1_hallway.tscn")

func change_scene(scene, direction):
	TransitionScreen.transition(direction)
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(scene)
