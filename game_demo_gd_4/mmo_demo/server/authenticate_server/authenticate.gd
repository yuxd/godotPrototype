extends Node

var network := ENetMultiplayerPeer.new()
var port := 1911
var max_servers := 5

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_servers)
	get_tree().get_multiplayer().multiplayer_peer = network
	print("athentication server started")
	
	network.connect("peer_connected", self._peer_connected)
	network.connect("peer_disconnected", self._peer_disconnected)


func _peer_connected(gateway_id : int):
	print("gateway " , gateway_id, " connected")


func _peer_disconnected(gateway_id : int):
	print("gateway " , gateway_id, " disconnected")

@rpc 
func authenticate_player(username, password, player_id):
	pass
