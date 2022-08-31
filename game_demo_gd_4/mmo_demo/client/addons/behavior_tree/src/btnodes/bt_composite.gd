class_name BTComposite, "res://addons/behavior_tree/icons/btcomposite.svg"
extends BTNode

# Executes every child, waiting for completion. Always succeeds.
#
# Can be used to create custom flows inside a group of children BTNodes.
# Most of your needs are probably satisfied by the ones I already provided
# to you, but you may have some specific flow in your game. In that case,
# you can extend this script and define it yourself.
# 执行每个子项，等待完成。总是成功
# 可用于在一组子节点内创建自定义流
# 你的大部分需求可能都得到了我已经提供的满足
# 对你来说，但你可能在游戏中有一些特定的流程。那样的话
# 您可以扩展这个脚本并自己定义它

@onready var children: Array = get_children() as Array

var bt_child: BTNode # Used to iterate over children

func _ready():
	assert(get_child_count() > 1, "A BTComposite must have more than one child.")

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var result
	
	for c in children:
		bt_child = c
		result = bt_child.tick(agent, blackboard)
#		if result is GDScriptFunctionState:
#			result = yield(result, "completed")
	return succeed()
