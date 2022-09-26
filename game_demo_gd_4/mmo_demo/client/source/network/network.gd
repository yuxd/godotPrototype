extends Node

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1911
var max_player := 100

func _ready():
	if "--server" in OS.get_cmdline_args():
		start_network(true)
	else:
		start_network(false)

func start_network(is_server : bool) -> void:
	if is_server:
		start_server()
	else:
		start_client()
		
func start_server():
	network.create_server(port, max_player)
	multiplayer.multiplayer_peer = network
	print("server started")
	
	network.peer_connected.connect(self._peer_connected)
	network.peer_disconnected.connect(self._peer_disconnected)	


func start_client():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	print("client started")
	
	network.connection_failed.connect(self._on_connection_failed)
	network.connection_succeeded.connect(self._on_connection_succeded)


func _on_connection_failed():
	print("failed to connect to gateway server")

func _on_connection_succeded():
	print("succesfully connected to gateway server")

func _peer_connected(gateway_id : int):
	print("gateway " , gateway_id, " connected")


func _peer_disconnected(gateway_id : int):
	print("gateway " , gateway_id, " disconnected")
