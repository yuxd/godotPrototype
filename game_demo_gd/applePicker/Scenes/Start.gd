extends Control


onready var Popup_Setting = $Popup_Setting

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btn_Exit_pressed():
	# "退出游戏"
	get_tree().quit()



func _on_btn_Setting_pressed():
	Popup_Setting.popup()


func _on_btn_Start_pressed():
	GameInstance.goto_scene("res://Scenes/Main.tscn")
