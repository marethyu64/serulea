extends Node2D

signal character_swap

@export var speed = 100
@export var follow_mode = false
@export var character_controlling = "Lotus"
var has_switched_to_calin = false

@onready var lotus: CharacterBody2D = $Lotus
@onready var calin: CharacterBody2D = $Calin

var merge_distance = 200

func _ready() -> void:
	handle_follow_mode()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Perspective Change"):
		if follow_mode:
			handle_lotus_control()
		else:
			if has_switched_to_calin and calin.global_position.distance_to(lotus.global_position) <= merge_distance:
				handle_follow_mode()
				return
			match character_controlling:
				"Lotus": handle_calin_control()
				"Calin": handle_lotus_control()

func handle_follow_mode():
	print("Follow mode activated")
	character_swap.emit("follow")
	follow_mode = true
	calin.follow = true
	calin.active = false
	lotus.active = true
	has_switched_to_calin = false
	character_controlling = "Lotus"
	lotus.z_index = 2
	calin.z_index = 1

func handle_lotus_control():
	print("Controlling Lotus")
	character_swap.emit("lotus")
	character_controlling = "Lotus"
	follow_mode = false
	calin.follow = false
	lotus.active = true
	calin.active = false
	lotus.z_index = 2
	calin.z_index = 1
	
func handle_calin_control():
	print("Controlling Calin")
	character_swap.emit("calin")
	character_controlling = "Calin"
	has_switched_to_calin = true
	calin.active = true
	lotus.active = false
	lotus.z_index = 1
	calin.z_index = 2
