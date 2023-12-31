class_name BTDecorator, "res://addons/behavior_tree/icons/btdecorator.svg"
extends BTNode

# Accepts only ONE child. Ticks and sets its state the same as the child.
# Can be used to create conditions.
#只接受一个孩子。勾选并将其状态设置为与子对象相同
#可以用来创造条件

@onready var bt_child: BTNode = get_child(0) as BTNode

func _ready():
	assert(get_child_count() == 1, "A BTDecorator can only have one child.")


func _tick(agent: Node, blackboard: Blackboard) -> void:
	tick_current_child()


func tick_current_child() -> bool:
	var c = get_child(0)
	c.ticked.connect(self._on_child_ticked)
	c.tick(agent, blackboard)
	return true


func _on_child_ticked(result : bool) -> void:
	pass
