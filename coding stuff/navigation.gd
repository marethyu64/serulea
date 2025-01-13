extends Node

@export var direction_exit : String

func change_scene(scene, direction, spawn_point):
	TransitionScreen.transition(direction)
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file(scene)
	var packed_scene = load(scene)
	var new_scene = packed_scene.instantiate()
	var position_to_teleport = new_scene.get_node("SpawnPoints").get_node(spawn_point).global_position
	Player.global_position = position_to_teleport
	Player.lotus.global_position = position_to_teleport
	Player.calin.global_position = position_to_teleport
