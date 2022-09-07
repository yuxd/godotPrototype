extends BTLeaf
class_name BTMoveTo


func _tick(agent: Node, blackboard: Blackboard) -> void:
	'''tick'''
	var pos : Vector2 = blackboard.get_data("move_position")
	printerr(pos)
