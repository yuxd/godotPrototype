extends Node

func _ready():
	var err = Client.connect("create_player",self,"on_create_player")
	Client.connect( "broadcast_world_chat",self,"on_broadcast_world_chat")
	Client.connect( "broadcast_player_position",self,"on_broadcast_player_position")
	# Client.connect( "broadcast_action",self,"on_broadcast_action")
	# Client.connect( "broadcast_delect_player",self, "on_broadcast_delect_player")
	# Client.connect( "sync_players",self,"on_sync_players")

func on_create_player(player_id):
	print("成功创建了玩家对象,玩家ID：",player_id)

func on_broadcast_world_chat(content):
	print("世界聊天，说了：",content)

func on_broadcast_player_position(position):
	print("移动位置，x:",position.get_X(),
		"y:",position.get_Y(),
		"z:",position.get_Z(),
		"v:",position.get_V())

