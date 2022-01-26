extends Node

var conn = StreamPeerTCP.new()
const server_IP : String = "127.0.0.1"
const server_port : int = 8999

var revice_thread : Thread

func _ready():
	conn.connect_to_host(server_IP,server_port)
	if conn.is_connected_to_host():
		print("连接服务器成功")
		revice_thread = Thread.new()
		revice_thread.start(self,"revice")
	else:
		print("连接服务器失败")

func revice():
	pass
