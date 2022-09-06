class_name BTSelector, "res://addons/q_framework/behavior_tree_ecs/icons/btselector.svg"
extends BTComposite

# Ticks its children until ANY of them succeeds, thus succeeding.
# If ALL of the children fails, it fails as well.
var current_child_index := 0

func _tick(agent: Node, blackboard: Blackboard) -> void:
	var result
#	for c in children:
#		bt_child = c
#		result = await bt_child.tick(agent, blackboard)
#		if bt_child.succeeded():
	tick_current_child()


func _on_child_ticked(result : bool):
	if result == true:
		current_child_index = 0		
		ticked.emit(succeed())
	else :
		current_child_index += 1
		if current_child_index <= children.size():
			tick_current_child()
		else:
			current_child_index = 0
			ticked.emit(fail())	


func tick_current_child() -> void:
	var c = children[current_child_index]
	c.ticked.connect(self._on_child_ticked)
	c.tick(agent, blackboard)
