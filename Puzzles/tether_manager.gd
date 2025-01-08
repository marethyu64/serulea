extends Node2D

signal tether_request
signal puzzle_completion

@onready var number_of_tethers = get_child_count()

var tethers : int = 0

@export var puzzle_completed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("Left Click") and not puzzle_completed: disable_tethers()


func _on_tether_request(tether1, tether2) -> void:
	if tether2.input == false and tether2.output == false:
		tether1.output = true
		tether2.input = true
		tethers += 1
		tether1.get_node("TetherLead").global_position = tether2.global_position
		tether1.get_node("Line2D").points[1] = tether1.get_node("Line2D").to_local(tether2.global_position)
		tether2.shoot = true
		
		if check_completion(): 
			print("puzzle completed!")
			puzzle_completion.emit()
		

func check_completion():
	var inputs = 0
	var outputs = 0
	for tether in get_children():
		if tether.input == true: inputs += 1
		if tether.output == true: outputs += 1
	if (inputs == number_of_tethers - 1) and (outputs == number_of_tethers - 1): 
		for tether in get_children(): tether.shoot = false
		puzzle_completed = true
		return true
	else: 
		return false

func disable_tethers():
	for tether in get_children():
		tether.output = false
		tether.input = false
		tether.shoot = false
