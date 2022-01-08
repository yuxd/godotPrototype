extends Control

onready var text_edit = $TextEdit
onready var lable_chat = $Label
const MyProto  = preload("res://pb/msg.proto.gd")

func _ready():
	lable_chat.text = ""
	Client.connect("broadcast_world_chat",self,"broadcast_world_chat")

func _on_Button_pressed():
	var talk_content = text_edit.text
	var data = MyProto.Talk.new()
	data.set_Content(talk_content)
	var msg_id = 2
	Client.send_message(msg_id, data)
	print("尝试发送talk数据,msgID:", msg_id, "消息内容：", talk_content)

func broadcast_world_chat(player_id,content):
	print("content: ", content)
	var t = lable_chat.text
	lable_chat.text = t + "player ID: " + player_id + " connent : " + content + "/n"
	
