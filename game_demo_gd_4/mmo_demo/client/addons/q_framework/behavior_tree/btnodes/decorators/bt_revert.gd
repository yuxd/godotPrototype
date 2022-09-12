class_name BTRevert, "res://addons/q_framework/behavior_tree/icons/btrevert.svg"
extends BTDecorator

# Succeeds if the child fails and viceversa.
# 如果孩子失败，则成功，反之亦然。

func _tick(agent: Node, blackboard: Blackboard) -> void:
	bt_child.tick(agent, blackboard)


func _on_child_ticked(result : bool) -> void:
	if bt_child.succeeded():
		ticked.emit(fail())
	else:
		ticked.emit(succeed())
