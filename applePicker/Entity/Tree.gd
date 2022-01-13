extends Sprite


onready var apple = preload("res://Entity/Apple.tscn")
var speed = 150
var direction = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dropApple();
	checkDirection();
	move(delta);

func dropApple():
	var r = rand_range(0,5000)
	if r < 10:
		var instance = apple.instance()
		self.add_child(instance)

func checkDirection():
	if position.x <= 33||position.x >= 990:
		direction = direction*-1;

func move(delta):
	position.x =  speed * direction * delta + position.x
