class_name BTTest
extends BTLeaf

func _tick(agent: Node, blackboard: Blackboard) -> void:
	print_debug("bt_test")
	ticked.emit(succeed()) 
