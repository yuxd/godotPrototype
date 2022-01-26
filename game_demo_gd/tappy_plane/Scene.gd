extends Node2D

export var speed : int = 10
export var rock_count_max : int = 20

var array_rock = []

export var rock_x_max = 104
export var rock_y_min = 584
export var rock_y_max = 728
export var rock_down_y_min = -96

onready var t_rock = load("res://Rock.tscn")
onready var t_rock_down = load("res://Rock_down.tscn")
onready var rock_root = $RockRoot

# Called when the node enters the scene tree for the first time.
func _ready():
	_instance_rock()


func _physics_process(delta):
	self.position.x = self.position.x - speed * delta
	if position.x <= -1023 :
		self.position.x = 1023
		_instance_rock()
			
func _instance_rock():
		for r in array_rock:
			rock_root.remove_child(r)
		array_rock.clear()
		
		var rock_count = randi() % rock_count_max
		for i in rock_count :
			var r = t_rock.instance()
			r.position.x = (randi() % 1020/10) * 10
			r.position.y = int(rand_range(rock_y_min,rock_y_max))
			r.z_index = 1
			array_rock.append(r)
			rock_root.add_child(r)
		
		for i in rock_count :
			var r = t_rock_down.instance()
			r.position.x = (randi() % 1020/10) * 10
			r.position.y = int(rand_range(rock_down_y_min,8))
			r.z_index = 1
			array_rock.append(r)
			rock_root.add_child(r)
