extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal on_transition_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name):
	animation_player.play("exit_" + anim_name.substr(6))
	on_transition_finished.emit()

func transition(direction):
	animation_player.play("enter_" + str(direction))
	
