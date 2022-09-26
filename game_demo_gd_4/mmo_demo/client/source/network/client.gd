extends Node

var conn = StreamPeerTCP.new()
const server_IP : String = "127.0.0.1"
const server_port : int = 8999

var revice_thread : Thread
var json := JSON.new()
const REQ_LOGIN_ID = 1

func _ready():
	var error := conn.connect_to_host(server_IP,server_port)
	if error == OK:
		print("连接服务器成功")
		revice_thread = Thread.new()
		revice_thread.start(self.revice)
	else:
		print("连接服务器失败")
	
	# var d = {}
	# d["username"] = "weimin"
	# send_message(1,d)
	
func revice():
	while true:
		var msg_len = conn.get_u32()
		var msg_ID = conn.get_u32()
		var msg = conn.get_partial_data(msg_len)
		var err = msg[0]
		var data : String= msg[1].get_string_from_utf8()
		match msg_ID :
			101:
				var json_data = json.parse(data)
				print(json_data)

func send_message(data_id :int, data : Dictionary):
	var json_packet: String = json.print(data)
	var data_len = json_packet.length()
	conn.put_u32(data_len)
	conn.put_u32(data_id)
	conn.put_partial_data(json_packet.to_utf8_buffer())
