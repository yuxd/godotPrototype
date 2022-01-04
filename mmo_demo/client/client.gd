extends Node

var conn = StreamPeerTCP.new()
const server_IP = '127.0.0.1'
const server_port = 8999
const MyProto  = preload("res://pb/msg.proto.gd")

var revice_thread : Thread

func _ready():
	conn.connect_to_host(server_IP, server_port)
	print("尝试连接到服务器,IP: ",server_IP," Port: ",server_port)
	if conn.is_connected_to_host():
		print("链接服务器成功")
		# 开一个线程读取服务器发来的数据
		revice_thread = Thread.new()
		revice_thread.start(self,"revice")
	else:
		print("连接服务器失败")
		
func send_message(msg):
	conn.put_data(msg.to_utf8())

func revice(_all):
	while true:
		var msg_len = conn.get_u32()
		var msg_id = conn.get_u32()
		
		var msg : PoolByteArray
		for i in range(0,msg_len):
			msg.append(conn.get_u8())

		print("msgID: ",msg_id," msg: ",msg)
		
		if msg_id == 1:
			var data = MyProto.SyncPID.new()
			var result_code = data.from_bytes(msg)
			if result_code == MyProto.PB_ERR.NO_ERRORS:
				print("OK")
			else:
				return
			# Use class 'a' fields. Example, get field f1
			var player_id = data.get_PID()
			print("player ID: ",player_id)
		else:
			pass
		# if rev_bytes > 0:
		# 	print("rev_num : ",rev_bytes)
		# 	var data = conn.get_utf8_string(rev_bytes)
		# 	print("data : ",data)
		# 	continue

func _exit_tree():
	# 退出
	conn.disconnect_from_host()

# Unpack 拆包方法(解压数据)
func unpack(binaryData : PoolByteArray) ->  Dictionary :
	
	# 创建一个从输入二进制数据的ioReader
	var dataBuff : PoolByteArray

	# 只解压head的信息，得到dataLen和msgID
	var msg = {}

	# 读dataLen
	# binary.Read(dataBuff, binary.LittleEndian, msg.DataLen)

	# 读msgID
	# binary.Read(dataBuff, binary.LittleEndian, msg.ID)

	# 判断dataLen的长度是否超出我们允许的最大包长度
	# if utils.GlobalObject.MaxPacketSize > 0 && msg.DataLen > utils.GlobalObject.MaxPacketSize 
	# return nil, errors.New("too large msg data received")

	# 这里只需要把head的数据拆包出来就可以了，然后再通过head的长度，再从conn读取一次数据
	return msg



