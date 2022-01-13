extends KinematicBody2D

export (int) var speed = 200
export (int) var x_min = 33
export (int) var x_max = 991

var velocity = Vector2()

func _ready():
	pass

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	# if Input.is_action_pressed('move_down'):
	# 	velocity.y += 1
	# if Input.is_action_pressed('move_up'):
	# 	velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	if position.x >= x_max :
		position.x = x_max
	elif position.x <= x_min:
		position.x = x_min
