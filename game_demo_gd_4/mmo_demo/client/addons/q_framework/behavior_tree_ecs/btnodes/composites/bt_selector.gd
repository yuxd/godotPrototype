class_name BTSelector, "res://addons/q_framework/behavior_tree_ecs/icons/btselector.svg"
extends BTComposite

# Ticks its children until ANY of them succeeds, thus succeeding.
# If ALL of the children fails, it fails as well.

func _tick(agent: Node, blackboard: Blackboard) -> void:
	tick_current_child()


func _on_child_ticked(result : bool) -> void:
	if result == true:
		current_child_index = 0		
		ticked.emit(succeed())
	else :
		if not tick_current_child():
			ticked.emit(fail())
