extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Player.character_swap.connect(change_visiblity)

func change_visiblity(swapped_character):
	if swapped_character == "lotus":
		visible = true
	else:
		visible = false
