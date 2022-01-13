extends Sprite

export(float) var drop_speed = 10

func _ready():
	pass 

func _process(delta):
	position.y = position.y + drop_speed * delta
	if position.y >= 550:
		self.queue_free()

func _on_Area2D_area_entered():
	pass
