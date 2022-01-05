extends Node

onready var t_player = reload("res://icon.png")
var players = {}

func _ready():
	
	
	var err = Client.connect("create_player",self,"create_player")
	Client.connect( "broadcast_world_chat",self,"on_broadcast_world_chat")
	Client.connect( "broadcast_player_position",self,"on_broadcast_player_position")
	# Client.connect( "broadcast_action",self,"on_broadcast_action")
	# Client.connect( "broadcast_delect_player",self, "on_broadcast_delect_player")
	# Client.connect( "sync_players",self,"on_sync_players")

func create_player(player_id):
	var player = t_player.instance()
	get_scene_tree().add_child(player)
	players[player_id] = player

	print("成功创建了玩家对象,玩家ID：",player_id)

func on_broadcast_world_chat(player_id,content):	
	print("ID",player_id,"的玩家世界聊天，说了：",content)	
		
func on_broadcast_player_position(player_id,position):	
	if players.has(player_id):	
		player.set_pisition(position.get_X(),position.get_Z())
	else:	
		create_player(player_id)	
    print("ID: ",player_id,"的玩家移动了位置，x:",position.get_X(),	
        "y:",position.get_Y(),	
        "z:",position.get_Z(),	
        "v:",position.get_V())	
		

