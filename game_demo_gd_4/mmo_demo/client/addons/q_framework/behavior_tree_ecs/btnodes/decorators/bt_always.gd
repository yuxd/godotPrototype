class_name BTAlways, "res://addons/q_framework/behavior_tree_ecs/icons/btalways.svg"
extends BTDecorator

# 执行子级，并且总是任何一个成功或失败
@export_enum("Fail", "Succeed") var always_what : int
@onready var return_func: String = "fail" if always_what == 0 else "succeed"

func _on_child_ticked(result : bool) -> void:
	return call(return_func)
