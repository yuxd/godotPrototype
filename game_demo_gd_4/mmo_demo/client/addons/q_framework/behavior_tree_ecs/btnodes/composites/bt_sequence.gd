class_name BTSequence, "res://addons/q_framework/behavior_tree_ecs/icons/btsequence.svg" 
extends BTComposite

# Ticks its children as long as ALL of them are successful.
# Successful if ALL the children are successful.
# Fails if ANY of the children fails.

func _tick(agent: Node, blackboard: Blackboard) -> void:
	tick_current_child()


func _on_child_ticked(result : bool) -> void:
	if result == false:
		current_child_index = 0		
		ticked.emit(fail())
	else :
		if not tick_current_child():
			ticked.emit(succeed())
