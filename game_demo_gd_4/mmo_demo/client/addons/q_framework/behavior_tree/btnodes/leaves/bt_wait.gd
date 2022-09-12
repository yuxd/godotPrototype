class_name BTWait, "res://addons/q_framework/behavior_tree/icons/btwait.svg"
extends BTLeaf

# Waits for wait_time seconds, then succeeds. time_in_bb is the key where, 
# if desired, another amount can be specified. In that case, wait_time is overridden.


@export var wait_time: float
@export var time_in_bb: String


func _tick(agent: Node, blackboard: Blackboard) -> void:
	if time_in_bb:
		wait_time = blackboard.get_data(time_in_bb)
	await get_tree().create_timer(wait_time, false).timeout
	if not canceled():
		ticked.emit(succeed())
