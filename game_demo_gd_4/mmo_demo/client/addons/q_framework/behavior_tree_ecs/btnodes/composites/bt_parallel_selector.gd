class_name BTParallelSelector
extends BTComposite

# Executes each child. doesn't wait for completion, always succeeds.
@export var is_succeed := true

func _tick(agent: Node, blackboard: Blackboard) -> void:
	'''
	Executes each child. doesn\'t wait for completion, always succeeds.
	'''
	for c in children:
		bt_child = c
		bt_child.ticked.connect(self._on_child_ticked)
		bt_child.tick(agent, blackboard)


func _on_child_ticked(result : bool) -> void:
	if result == is_succeed :
		for c in children:
			c.cancel()
		if result:
			ticked.emit(succeed())
		else:
			ticked.emit(fail())
