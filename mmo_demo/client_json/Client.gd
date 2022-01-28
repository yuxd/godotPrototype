extends Node

var conn = StreamPeerTCP.new()
const server_IP : String = "127.0.0.1"
const server_port : int = 8999

var revice_thread : Thread

const REQ_LOGIN_ID = 1


func _ready():
	conn.connect_to_host(server_IP,server_port)
	if conn.is_connected_to_host():
		print("连接服务器成功")
		revice_thread = Thread.new()
		revice_thread.start(self,"revice")
	else:
		print("连接服务器失败")
	
	# var d = {}
	# d["username"] = "weimin"
	# send_message(1,d)
	
func revice():
	pass

func send_message(data_id :int, data : Dictionary):
	var json_packet: String = JSON.print(data)
	var data_len = json_packet.length()
	conn.put_u32(data_len)
	conn.put_u32(data_id)
	conn.put_partial_data(json_packet.to_ascii())
