extends Node

func _ready():
	Client.connect("create_player",self,"on_create_player")

func on_create_player(player_id):
	print("成功创建了玩家对象,玩家ID：",player_id)

