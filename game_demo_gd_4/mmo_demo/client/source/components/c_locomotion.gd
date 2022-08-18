class_name LocomotionComponent
extends Node

enum Facing { LEFT, RIGHT, UP }

const component_name := "C_Locomotion"

#@export var max_speed_default := Vector2(500.0, 500.0)
@export var speed := 50

var facing: int = Facing.RIGHT
var is_on_floor: bool = true
var max_speed: Vector2
var velocity: Vector2

#func _ready() -> void:
#	max_speed = max_speed_default
