extends Control

onready var te_username = $te_username
onready var te_password = $te_password

func _on_btn_login_pressed():
	# 获取到玩家输入的用户名和密码
	var dic_login = {}
	dic_login["username"] = te_username.text
	dic_login["password"] = te_password.text
	# 调用client 单例 的sendMessage方法
	Client.send_message(Client.REQ_LOGIN_ID, dic_login)
