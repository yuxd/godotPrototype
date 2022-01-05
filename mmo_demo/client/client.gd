extends Node

var conn = StreamPeerTCP.new()
const server_IP = '127.0.0.1'
const server_port = 8999
const MyProto  = preload("res://pb/msg.proto.gd")

signal create_player
signal broadcast_world_chat
signal broadcast_player_position
signal broadcast_action
signal broadcast_delect_player 
signal sync_players

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
		
func revice(_all):
	while true:
		var msg_len = conn.get_u32()
		var msg_id = conn.get_u32()
		
		var msg : PoolByteArray
		for i in range(0,msg_len):
			msg.append(conn.get_u8())

		print("msgID: ",msg_id," msg: ",msg)
		
		match  msg_id:
			1: # 分配玩家ID
				var data = MyProto.SyncPID.new()
				var result_code = data.from_bytes(msg)
				if result_code != MyProto.PB_ERR.NO_ERRORS:
					return
				# Use class 'a' fields. Example, get field f1
				var player_id = data.get_PID()
				print("player ID: ",player_id)
				emit_signal("create_player",player_id)
			200:
				var data = MyProto.BroadCast.new()
				var result_code = data.from_bytes(msg)
				if result_code != MyProto.PB_ERR.NO_ERRORS:
					return
				# Use class 'a' fields. Example, get field f1
				var player_id = data.get_PID()
				var msg_type = data.get_tp
				match msg_type:
					1: # 世界聊天	
						var content = data.get_Content()
						emit_signal("broadcast_world_chat",content)
					2: # 玩家位置	
						var position = data.get_P()
						emit_signal("broadcast_player_position",position)
					3: # 动作	
						var action = data.get_ActionData()
						emit_signal("broadcast_action",action)
					4: # 移动之后坐标信息更新	
						print("移动后更新坐标信息，暂未实现")
					_: # 其他情况	
						print("未定义消息类型！")
			201: # 广播消息 掉线/aoi 消失在视野		
				var data = MyProto.SyncPid.new()	
				var result_code = data.from.bytes(msg)	
				if result_code == MyProto.PB_ERR.NO_ERRORS:	
					var player_id = data.get_PID()
					emit_signal("broadcast_delect_player", player_id)
			202: # 同步周围的人位置信息		
				var data = MyProto.SyncPlayers.new()	
				var result_code = data.from.bytes(msg)	
				if result_code == MyProto.PB_ERR.NO_ERRORS:	
					var players = data.get_ps()
					emit_signal("sync_players", players)
			_:
				print("未定义的协议ID！")


func _exit_tree():
	# 退出
	conn.disconnect_from_host()

func send_message(msg_id,msg_data):		
	var packed_bytes : PoolByteArray = msg_data.to_bytes()
	var msg_len = packed_bytes.size()
	conn.put_u32(msg_len)
	conn.put_u32(msg_id)
	for p in packed_bytes:
		conn.put_u8(p)

