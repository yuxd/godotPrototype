extends BTLeaf
class_name BTGetRandomPosition

func _tick(agent: Node, blackboard: Blackboard) -> void:
	'''tick'''
	var position : Vector2 = BehaviorTreeSystem.get_random_position(agent) + agent.position
	blackboard.set_data("move_position", position)
	ticked.emit(succeed())
