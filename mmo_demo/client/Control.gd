extends Control

onready var text_edit = $TextEdit
onready var lable_chat = $Label
const MyProto  = preload("res://pb/msg.proto.gd")

func _ready():

	Client.connect("broadcast_world_chat",self,"_on_broadcast_world_chat")
	print(lable_chat.text)
	lable_chat.text = ""

func _on_Button_pressed():
	var talk_content = text_edit.text
	var data = MyProto.Talk.new()
	data.set_Content(talk_content)
	var msg_id = 2
	Client.send_message(msg_id, data)
	print("尝试发送talk数据,msgID:", msg_id, "消息内容：", talk_content)


func _on_broadcast_world_chat(player_id, content):
	var t = lable_chat.text
	print("ID",player_id,"的玩家世界聊天，说了：",content)	
	lable_chat.text = t + "player ID: {player_id} content: {content} \n".format({"player_id":player_id,"content":content})
	 
