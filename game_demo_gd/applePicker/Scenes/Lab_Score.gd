extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameInstance.connect("change_score",self,"_change_score")
	self.text = "分数：" + String(GameInstance.Score)
	


func _change_score(_n: int):
	self.text = "分数：" + String(GameInstance.Score)
