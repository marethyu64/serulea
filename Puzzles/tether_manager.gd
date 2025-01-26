extends Node2D

signal tether_request
signal puzzle_completion
signal delete_tether

@onready var number_of_tethers = get_child_count()

const TETHER = preload("res://Puzzles/tether.tscn")
const MOUSE_DISTANCE_TO_TETHER = 60

var can_tether : bool = true

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
	if Input.is_action_just_pressed("Left Click") and can_tether == true:
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
				var group_to_remove = tether2.group
				for tether in get_children():
					if tether.group == group_to_remove: 
						tether.group = tether1.group
		
		new_tether.tether1 = tether1
		new_tether.tether2 = tether2
		new_tether.get_node("Line2D").set_point_position(1, new_tether.to_local(tether2.global_position))
		new_tether.tether_complete.emit()
		tether1.tethers += 1
		tether2.tethers += 1
		dragging_tether = false
		new_tether = null
		current_energy_tether = null
		select_tether(tether2)
		if check_completion() == true:
			print("finish!!!!")

func check_completion():
	var prev_group = get_child(0).group
	for tether in get_children():
		if tether.group == 0 or tether.group != prev_group:
			return false
	return true

func calculation_every_fucking_thing():
	var checked_tethers = []
	var checked_lines = []
	group_ticket = 1
	
	for tether in get_children(): tether.group = 0
	
	for tether in get_children():
		if checked_tethers.has(tether): continue
		var found_line : bool = false
		for line_2d in tether.get_children():
			if line_2d.name == "Tether":
				checked_tethers.append(tether)
				found_line = true
				if checked_lines.has(line_2d): continue
				tether.group = group_ticket
				find_connections(line_2d,tether,checked_tethers,checked_lines)
				if tether.tether_line_1 != line_2d and tether.tether_line_1 != null: find_connections(tether.tether_line_1,tether,checked_tethers,checked_lines)
				if tether.tether_line_2 != line_2d and tether.tether_line_2 != null: find_connections(tether.tether_line_2,tether,checked_tethers,checked_lines)
				group_ticket += 1
		#if found_line == false: tether.group = 0
		
func find_connections(line_2d,tether,checked_tethers,checked_lines):
	var found_line = null
	var found_tether = null
	if line_2d.tether1 != tether and line_2d.tether1 != null and not checked_tethers.has(line_2d.tether1): found_tether = line_2d.tether1
	if line_2d.tether2 != tether and line_2d.tether2 != null and not checked_tethers.has(line_2d.tether2): found_tether = line_2d.tether2
	if found_tether != null: 
		found_tether.group = group_ticket
		checked_tethers.append(found_tether)
		if found_tether.tether_line_1 != line_2d and found_tether.tether_line_1 != null and not checked_lines.has(found_tether.tether_line_1): found_line = found_tether.tether_line_1
		if found_tether.tether_line_2 != line_2d and found_tether.tether_line_2 != null and not checked_lines.has(found_tether.tether_line_2): found_line = found_tether.tether_line_2
		if found_line != null:
			checked_lines.append(found_line)
			find_connections(found_line,found_tether,checked_tethers,checked_lines)

func character_swapped(swapped_character):
	if swapped_character == "calin":
		can_tether = false
		for tether in get_children(): tether.visible = false
		if dragging_tether:
			dragging_tether = false
			new_tether.queue_free()
			new_tether = null
			current_energy_tether = null
	else: 
		for tether in get_children(): tether.visible = true
		can_tether = true


func _on_delete_tether(tether_to_delete):
	tether_to_delete.queue_free()
	await get_tree().create_timer(.1).timeout
	calculation_every_fucking_thing()
