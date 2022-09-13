class_name BTRepeat, "res://addons/q_framework/behavior_tree/icons/btrepeat.svg"
extends BTDecorator

# Executes child "iterations" times and returns the last state and tick result
# 执行子“迭代”次数并返回最后状态和勾选结果

@export_range(0, 999) var times_to_repeat: int = 1
@export var frequency : float

var result_count : int = times_to_repeat

func _tick(agent: Node, blackboard: Blackboard) -> void:
	for i in times_to_repeat:
		bt_child.tick(agent, blackboard)
		await (get_tree().create_timer(frequency, false).timeout)


func _on_child_ticked(result : bool) -> void:
	if result_count <= 0 :
		ticked.emit(set_state(bt_child.state))
		result_count = times_to_repeat
	else:
		result_count -= 1
