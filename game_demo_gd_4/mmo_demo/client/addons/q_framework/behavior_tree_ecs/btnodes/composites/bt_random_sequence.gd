class_name BTRandomSequence, "res://addons/q_framework/behavior_tree_ecs/icons/btrndsequence.svg"
extends BTSequence

# Just like a BTSequence, but the children are executed in random order.


func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	randomize()
	children.shuffle()
