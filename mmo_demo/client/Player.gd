extends Node2D

const MyProto  = preload("res://pb/msg.proto.gd")
export (int) var speed = 200

var velocity = Vector2()

func _ready():
	pass
	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if velocity.x != 0 or velocity.y != 0:
		var data = MyProto.Position.new()
		data.set_X(position.x + velocity.x)
		data.set_Z(position.y + velocity.y)
		Client.send_message(3,data)

func _physics_process(delta):
	get_input()
	# velocity = move_and_slide(velocity)
