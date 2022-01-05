extends Node

var t_player = load("res://Player.tscn")
var players = {}

func _ready():
	
	Client.connect("create_player",self,"on_create_player")
	Client.connect( "broadcast_world_chat",self,"on_broadcast_world_chat")
	Client.connect( "broadcast_player_position",self,"on_broadcast_player_position")
	# Client.connect( "broadcast_action",self,"on_broadcast_action")
	# Client.connect( "broadcast_delect_player",self, "on_broadcast_delect_player")
	# Client.connect( "sync_players",self,"on_sync_players")

func on_create_player(player_id):
	print("开始创建了玩家对象,玩家ID：",player_id)
	var instance = t_player.instance()
	add_child(instance)
	players[player_id] = instance
	print("成功创建了玩家对象,玩家ID：",player_id)


func on_broadcast_world_chat(player_id,content):	
	print("ID",player_id,"的玩家世界聊天，说了：",content)	
		
func on_broadcast_player_position(player_id,position):
	print("尝试移动ID: ",player_id,"的玩家位置，x:",position.get_X(),	
		"y:",position.get_Y(),	
		"z:",position.get_Z(),	
		"v:",position.get_V())		
	if players.has(player_id):	
		var player = players[player_id]
		print("找到对应player，尝试移动位置")
		player.position.x = position.get_X()
		player.position.y = position.get_Z()
	else:	
		print("没有找到对应player，尝试重新创建")
		on_create_player(player_id)	

	print("ID: ",player_id,"的玩家移动了位置，x:",position.get_X(),	
		"y:",position.get_Y(),	
		"z:",position.get_Z(),	
		"v:",position.get_V())	
		

