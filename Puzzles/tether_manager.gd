extends Node2D

signal tether_request

@onready var number_of_tethers = get_child_count()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Director is so lame")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tether_request() -> void:
	print("wazaaaa")
