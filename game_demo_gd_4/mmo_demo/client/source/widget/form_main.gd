extends Control

@onready var tb_main := $vb/mc/hb/tb_main
@onready var w_main := $vb/w_main_body

func _ready():
	tb_main.connect("tab_changed", _on_tb_main_tab_changed)
	pass

func _on_tb_main_tab_changed(tab: int):
	w_main.set_tc_main(tab)


func _on_btn_server_pressed():
#	Network.start_server()
	pass

func _on_btn_client_pressed():
#	Network.start_client()
	pass
