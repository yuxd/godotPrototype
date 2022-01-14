extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameInstance.connect("changeHP",self,"_changeHP")


func _changeHP(n:int):
	if GameInstance.HP <= 0:
		self.popup()

func _on_btn_ok_pressed():
	GameInstance.goto_scene("res://Scenes/Start.tscn")
