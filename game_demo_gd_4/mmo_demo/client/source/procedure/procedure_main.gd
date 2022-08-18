extends ProcedureBase
class_name ProcedureMain
#@onready var battle_main = preload("res://scenes/battle_main.tscn").instance()

var state_name := "procedure_main"
var game_main : GameMode
var p_system_manager : PackedScene

var form_main : Control

func enter(_msg := {}) -> void:
	print_debug(" procedure main enter")
	game_main = get_node("/root/main")
	var system_manager_path := Globals.system_path + "system_manager.tscn"
	assert(ResourceLoader.exists(system_manager_path))
	p_system_manager = load(system_manager_path)
	var system_manager = p_system_manager.instantiate()
	game_main.add_child(system_manager)
	form_main = GameInstance.ui_manager.show_form("form_main", game_main)
