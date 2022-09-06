extends System
class_name BehaviorTreeSystem

func _init():
	system_name = "S_BehaviorTree"
	requirements = ["C_BehaviorTree"]

func _ready() -> void:
	assert(get_child_count() == 1, "A Behavior Tree can only have one entry point.")
	bt_root.propagate_call("connect", ["tree_aborted", self, "abort"])
	start()

func start() -> void:
	if not is_active:
		return
	
	match sync_mode:
		0:
			set_physics_process(false)
			set_process(true)
		1:
			set_process(false)
			set_physics_process(true)

func abort() -> void:
	is_active = false
