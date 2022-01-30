extends Node2D


export var drop_speed = 50
export var drop_max = 650
export var player_name = "zhangsan"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position.y = position.y + drop_speed * delta
	
	
	
	if position.y >= drop_max:
		get_parent().remove_child(self)



func _on_RigidBody2D_body_entered(body):
	print("我是一个：" + name +  ",一个" + body.name + "进入我的区域")
	get_parent().remove_child(self)
	
