extends Node
class_name BehaviorTree

var b_jie : bool = true
var b_kun : bool = true

@onready var root_node : BTNode = get_child(0)

func _ready():
	root_node.completed.connect(_on_root_node_completed)
	root_node.run()

func _on_root_node_completed( _result : bool) -> void:
	root_node.run()
