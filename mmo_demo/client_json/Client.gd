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

	send_message(1,{"username":123456})

func revice():
	pass

func send_message(msg_id : int,msg_data:Dictionary):
	var json_packed : String = JSON.print(msg_data)
	# var msg : PoolByteArray
	var msg_len : int = json_packed.length()
	conn.put_u32(msg_len)
	conn.put_u32(msg_id)
	conn.put_partial_data(json_packed.to_ascii())
