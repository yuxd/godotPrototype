class_name BTTest
extends BTLeaf

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	print_debug("bt_test")
	return succeed()
