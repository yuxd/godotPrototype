# 游戏对象单例，进行一些游戏全局变量和常量定义，一些初始化工作
extends Node

var procedure_manager : ProcedureManager

const procedure_launch = preload("res://game_play/procedures/procedure_launch.gd")
const procedure_preload = preload("res://game_play/procedures/procedure_preload.gd")


func _ready():
    procedure_manager = QInstance.get_procedure_manager()
    procedure_manager.add_procedure("launch",procedure_launch)
    procedure_manager.add_procedure("preload",procedure_preload)
    procedure_manager.set_initial_procedure("launch")
    procedure_manager.launch()