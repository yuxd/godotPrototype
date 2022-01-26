extends Sprite


onready var apple = preload("res://Entity/Apple.tscn")
onready var audio = $AudioStreamPlayer2D

var speed = 150
var direction = 1
var spawn_num = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dropApple();
	checkDirection();
	move(delta);
	spawn_num += delta

func dropApple():
	var r = rand_range(0,5000)
	if r < spawn_num:
		var instance = apple.instance()
		instance.position = self.position
#		audio.play()
		get_parent().add_child(instance)
		
func checkDirection():
	if position.x <= 33||position.x >= 990:
		direction = direction*-1;

func move(delta):
	speed += delta * 10
	position.x = speed * direction * delta + position.x
