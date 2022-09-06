extends Node
class_name BehaviorTreeComponent, "res://addons/q_framework/behavior_tree_ecs/icons/bt.svg"

const component_name := "C_BehaviorTree"

# 这是你的主要节点。将其中一个放置在场景的根部，然后开始添加BTNodes。
# 行为树只接受一个入口点（因此只有一个子项），例如BTSequence或BTSelector。

@export var is_active: bool = false
@export var _blackboard : NodePath
@export var _agent : NodePath
@export_enum("Idle", "Physics") var sync_mode : int
@export var debug : bool = false

var tick_result

@onready var agent : Node = get_node(_agent) as Node
@onready var blackboard : Blackboard = get_node(_blackboard) as Blackboard
@onready var bt_root : BTNode = get_child(0) as BTNode

func _ready() -> void:
	assert(get_child_count() == 1, "A Behavior Tree can only have one entry point.")
	bt_root.propagate_call("connect", ["tree_aborted", self, "abort"])
	bt_root.ticked.connect(self._on_root_ticked)
	start()

func start() -> void:
	if not is_active:
		return
	bt_root.run()

func abort() -> void:
	is_active = false

func _on_root_ticked(result : bool) -> void:
	start()
