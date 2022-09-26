class_name BTParallel, "res://addons/q_framework/behavior_tree/icons/btparallel.svg"
extends BTComposite

# Executes each child. doesn't wait for completion, always succeeds.
var result_count := 0
func _tick(agent: Node, blackboard: Blackboard) -> void:
	'''
	Executes each child. doesn\'t wait for completion, always succeeds.
	'''
	for c in children:
		bt_child = c
		bt_child.ticked.connect(self._on_child_ticked)
		bt_child.tick(agent, blackboard)


func _on_child_ticked(result : bool) -> void:
	if result_count >= children.size() :
		result_count = 0
		ticked.emit(succeed())
	else:
		result_count += 1
