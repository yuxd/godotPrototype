class_name BTRepeatUntil, "res://addons/behavior_tree/icons/btrepeatuntil.svg"
extends BTDecorator

# Repeats until specified state is returned, then sets state to child state
# 重复，直到返回指定的状态，然后将状态设置为子状态

@export_enum("Failure", "Success") var until_what : int
@export var frequency : float

@onready var expected_result : bool = bool(until_what)


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var result = not expected_result
	
	while result != expected_result:
		result = await bt_child.tick(agent, blackboard)
		
#		if result is GDScriptFunctionState:
#			result = yield(result, "completed")
		
		await (get_tree().create_timer(frequency, false).timeout)
	
	return set_state(bt_child.state)
