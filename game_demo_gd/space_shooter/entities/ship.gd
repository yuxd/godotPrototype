extends KinematicBody2D

var velocity : Vector2
export (int) var speed = 200
onready var player_controller = $PlayerController

func _ready():
	player_controller.connect("update_position",self, "_on_upate_position")
	
func _on_upate_position(dreciton) -> void:
	velocity = dreciton * speed
	velocity = move_and_slide(velocity)
