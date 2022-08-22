extends ProcedureBase
class_name ProcedureLoadResource

var state_name := "procedure_load_resource"

var datatables = [
	"abilities",
	"buffs",
	"ability_effects",
	"battle_configs",
	"enemy",
	"battle_entities"
]

func _ready():
	datatables = GameInstance.data_model.datatables


func enter(_msg := {}) -> void:
	await ready
	print_debug(" procedure load resource enter")
	await GameInstance.load_datatables(datatables)
	# 异步加载资源完成后，跳转到游戏主逻辑
	state_machine.transition_to("procedure_main")


func exit():
	print_debug(" 退出 load resource 状态！")
