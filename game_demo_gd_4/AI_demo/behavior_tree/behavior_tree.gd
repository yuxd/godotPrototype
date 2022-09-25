extends Node
class_name BehaviorTree

@export var active : bool = true
@onready var root_node : BTNode = get_child(0)

func _ready():
	if not active:
		return
	root_node.completed.connect(_on_root_node_completed)
	root_node.run()

func _on_root_node_completed( _result : bool) -> void:
	root_node.run()
