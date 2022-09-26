extends Node

var network : ENetMultiplayerPeer = null
var gateway_api : MultiplayerAPI = null
var ip := "127.0.0.1"
var port := 1910

var username : String
var password : String

func _ready():
	connect_to_server("","")

func _process(delta):
	if gateway_api == null:
		return
	if not gateway_api.has_multiplayer_peer():
		return
	gateway_api.poll()

func connect_to_server(username, password):
	network = ENetMultiplayerPeer.new()
	gateway_api = MultiplayerAPI.new()
	self.username = username
	self.password = password
	
	network.create_client(ip, port)
	gateway_api.root_path = self.get_path()
	gateway_api.multiplayer_peer = network
	network.connect("connection_failed", self._on_connection_failed)
	network.connect("connection_succeded", self._on_connection_succeded)

func _on_connection_failed():
	print("failed to connect to gateway server")

func _on_connection_succeded():
	print("succesfully connected to gateway server")
