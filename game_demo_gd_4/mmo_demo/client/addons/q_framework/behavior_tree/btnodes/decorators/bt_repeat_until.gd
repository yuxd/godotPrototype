class_name BTRepeatUntil, "res://addons/q_framework/behavior_tree/icons/btrepeatuntil.svg"
extends BTDecorator

# Repeats until specified state is returned, then sets state to child state
# 重复，直到返回指定的状态，然后将状态设置为子状态

@export_enum("Failure", "Success") var until_what : int
@export var frequency : float

@onready var expected_result : bool = bool(until_what)


func _tick(agent: Node, blackboard: Blackboard) -> void:
	var result = not expected_result
	bt_child.tick(agent, blackboard)


func _on_child_ticked(result : bool) -> void:
	if result == expected_result:
		ticked.emit(set_state(bt_child.state))
	else:
		await (get_tree().create_timer(frequency, false).timeout)
		bt_child.tick(agent, blackboard)
