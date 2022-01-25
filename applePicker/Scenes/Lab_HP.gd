extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameInstance.connect("changeHP",self,"_changeHP")

	self.text = "生命值：" + String(GameInstance.HP)


func _changeHP(_n:int):
	self.text = "生命值：" + String(GameInstance.HP)
