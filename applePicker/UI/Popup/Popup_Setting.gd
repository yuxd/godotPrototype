extends Popup

onready var hs_audio = $HS_Audio
onready var hs_music = $HS_Music

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btn_Close_pressed():
	self.hide()
