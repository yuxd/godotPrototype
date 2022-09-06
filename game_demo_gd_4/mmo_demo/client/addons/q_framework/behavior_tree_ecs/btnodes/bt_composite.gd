class_name BTComposite, "res://addons/q_framework/behavior_tree_ecs/icons/btcomposite.svg"
extends BTNode

# 执行每个子项，等待完成。总是成功
# 可用于在一组子节点内创建自定义流
# 你的大部分需求可能都得到了我已经提供的满足
# 对你来说，但你可能在游戏中有一些特定的流程。那样的话
# 您可以扩展这个脚本并自己定义它

@onready var children: Array = get_children() as Array

var bt_child: BTNode # Used to iterate over children

func _ready():
	assert(get_child_count() > 1, "A BTComposite must have more than one child.")

func _tick(agent: Node, blackboard: Blackboard) -> void:
	var result
	
	for c in children:
		bt_child = c
		bt_child.tick(agent, blackboard)
