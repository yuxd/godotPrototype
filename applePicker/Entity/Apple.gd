extends Sprite

export(int) var drop_speed = 10

func _ready():
	pass 

func _process(delta):
	position.y = position.y + drop_speed * delta
	if position.y >= 550:
		self.queue_free()
