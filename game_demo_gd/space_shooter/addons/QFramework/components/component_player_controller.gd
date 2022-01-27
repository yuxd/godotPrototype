extends Node
class_name PlayerControllerComponent

var drection:Vector2
signal update_position

func get_input():
	drection = Vector2()
	if Input.is_action_pressed("ui_right"):
		drection.x += 1
	if Input.is_action_pressed('ui_left'):
		drection.x -= 1
	if Input.is_action_pressed('ui_down'):
		drection.y += 1
	if Input.is_action_pressed('ui_up'):
		drection.y -= 1
	drection = drection.normalized()

func _process(delta):
	get_input()
	emit_signal("update_position", drection)
