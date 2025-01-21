extends Node2D

signal tether_request
signal puzzle_completion

@onready var number_of_tethers = get_child_count()

const TETHER = preload("res://Puzzles/tether.tscn")
const MOUSE_DISTANCE_TO_TETHER = 60

var tethers : int = 0
var group_ticket : int = 0
var dragging_tether : bool = false

var new_tether : Node2D
var current_energy_tether : StaticBody2D

@export var puzzle_completed = false

func _ready():
	Player.character_swap.connect(character_swapped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Left Click"):
		for tether in get_children():
			if get_global_mouse_position().distance_to(tether.global_position) < MOUSE_DISTANCE_TO_TETHER:
				select_tether(tether)
	if Input.is_action_just_released("Left Click") and dragging_tether:
		dragging_tether = false
		new_tether.queue_free()
		new_tether = null
		current_energy_tether = null
	
	if dragging_tether:
		drag_tether()

func drag_tether():
	if not new_tether:
		return 

	var line_2d = new_tether.get_node("Line2D")
	var raycast = new_tether.get_node("RayCast2D")
	var mouse_position = new_tether.get_global_mouse_position()

	raycast.target_position = new_tether.to_local(mouse_position)
	raycast.force_raycast_update() 

	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		line_2d.set_point_position(1, new_tether.to_local(collision_point))
		var collider = raycast.get_collider()  
		if collider and collider is energy_tether:
			link_tether(current_energy_tether,collider)
	else:
		line_2d.set_point_position(1, new_tether.to_local(mouse_position))

func select_tether(tether):
	if tether.tethers < 2:
		dragging_tether = true
		current_energy_tether = tether
		new_tether = TETHER.instantiate()
		tether.add_child(new_tether)
		new_tether.global_position = tether.global_position  
		
		var line_2d = new_tether.get_node("Line2D")
		line_2d.set_point_position(0, Vector2.ZERO)
		line_2d.set_point_position(1, Vector2.ZERO)  

func link_tether(tether1,tether2):
	if tether2.tethers < 2:
		if tether1.group == 0 and tether2.group == 0:
			group_ticket += 1
			tether1.group = group_ticket
			tether2.group = group_ticket 
		elif tether1.group == tether2.group: 
			return
		elif tether1.group == 0 and tether2.group != 0:
			tether1.group = tether2.group
		elif tether1.group != 0:
			if tether2.group == 0: 
				tether2.group = tether1.group
			else:
				for tether in get_children():
					if tether.group == tether2.group: 
						tether.group = tether1.group
		
		new_tether.get_node("Line2D").set_point_position(1, new_tether.to_local(tether2.global_position))
		tether1.tethers += 1
		tether2.tethers += 1
		dragging_tether = false
		new_tether = null
		current_energy_tether = null
		if check_completion() == true:
			print("finish!!!!")

func check_completion():
	var prev_group = 0
	for tether in get_children():
		if tether.group == 0: return false
		if prev_group == 0 and tether.group != 0: tether.group = prev_group
		if tether.group != prev_group: return false
	return true
			

func character_swapped(swapped_character):
	if swapped_character == "calin":
		pass
