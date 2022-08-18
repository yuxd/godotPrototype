extends Node

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1911

func _ready():
	connect_to_server()
	
func connect_to_server():
	network.create_client(ip, port)
	get_tree().get_multiplayer().multiplayer_peer = network
	
	network.connect("connection_failed", self._on_connection_failed)
	network.connect("connection_succeded", self._on_connection_succeded)

func _on_connection_failed():
	print("failed to connect to authentication server")


func _on_connection_succeded():
	print("succesfully connected to authentication server")


func authenticate_player(username, password, player_id):
	pass
	
@rpc
func authentication_results(result, player_id):
	pass
