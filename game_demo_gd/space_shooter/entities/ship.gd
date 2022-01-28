extends KinematicBody2D

export (int) var speed = 200
onready var move_controller = $MoveController

func _ready():
	move_controller.speed = 100
