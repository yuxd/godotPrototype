extends Sprite

export(float) var drop_speed = 10

onready var audio = $AudioStreamPlayer2D

func _ready():
	pass 

func _process(delta):
	position.y = position.y + drop_speed * delta
	if position.y >= 550:
		GameInstance.emit_signal("changeHP",-1)
		self.queue_free()
	drop_speed += delta



func _on_Area2D_body_entered(body:Node):
	GameInstance.emit_signal("change_score",1)
	audio.play()
	self.queue_free()
