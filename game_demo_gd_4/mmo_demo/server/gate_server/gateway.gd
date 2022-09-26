extends Node

var network := ENetMultiplayerPeer.new()
var gateway_api := MultiplayerAPI.new()
#var custom_multiplayer : MultiplayerAPI
var port := 1910
var max_player := 100

func _ready():
	start_server()
	
func _process(delta):
	if not gateway_api.has_multiplayer_peer():
		return
	gateway_api.poll()
	
func start_server():
	network.create_server(port, max_player)
	gateway_api = MultiplayerAPI.new()
	gateway_api.root_path = self.get_path()
	gateway_api.multiplayer_peer = network
	
	network.connect("peer_connected", self._peer_connected)
	network.connect("peer_disconnected", self._peer_disconnected)


func _peer_connected(player_id : int):
	print("user " , player_id, " connected")


func _peer_disconnected(player_id : int):
	print("user " , player_id, " disconnected")
	
@rpc
func login_request(username, passworld):
	pass
