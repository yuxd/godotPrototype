class_name BTNode, "res://addons/behavior_tree/icons/btnode.svg" 
extends Node

# 行为树中的每个节点从中继承的基类
# 通常不需要直接实例化此节点
# 要定义您的行为，请使用并扩展BTLeaf

enum BTNodeState {
	FAILURE,
	SUCCESS,
	RUNNING,
	CANCEL,
}

# (Optional) Emitted after a tick() call. True is success, false is failure. 
signal ticked(result)
# Emitted if abort_tree is set to true
signal tree_aborted()
signal state_changed
# Turn this off to make the node fail at each tick.
@export var is_active: bool = true 
# Turn this on to print the name of the node at each tick.
@export var debug: bool = false 
# Turn this on to abort the tree after completion.
@export var abort_tree: bool

var _state : BTNodeState
var state: int : 
	set = set_state,
	get = _state_getter

var agent : Node = null
var blackboard : Blackboard = null

func _ready():
	ticked.connect(self._on_ticked)
	if is_active:
		succeed()
	else:
		push_warning("Deactivated BTNode '" + str(name) + "', path: '" + str(get_path()) + "'")
		fail()

### OVERRIDE THE FOLLOWING FUNCTIONS ###
# You just need to implement them. DON'T CALL THEM MANUALLY.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	'''预tick'''
	pass

# This is where the core behavior goes and where the node state is changed.
# You must return either succeed() or fail() (check below), not just set the state.
func _tick(agent: Node, blackboard: Blackboard) -> void:
	'''tick'''
	ticked.emit(true)


func _post_tick(agent: Node, blackboard: Blackboard, result: bool) -> void:
	'''tick后处理'''	
	pass

### DO NOT OVERRIDE ANYTHING FROM HERE ON ###

### BEGIN: RETURN VALUES ###

# Your _tick() must return one of the following functions.

# Return this to set the state to success.
func succeed() -> bool:
	_state = BTNodeState.SUCCESS
	return true

# Return this to set the state to failure.
func fail() -> bool:
	_state = BTNodeState.FAILURE
	return false

# Return this to match the state to another state.
func set_state(rhs: int) -> bool:
	state_changed.emit(rhs)
	match rhs:
		BTNodeState.SUCCESS:
			return succeed()
		BTNodeState.FAILURE:
			return fail()
	assert(false, "Invalid BTNodeState assignment. Can only set to success or failure.")
	return false

### END: RETURN VALUES ###

# Don't call this.
func run():
	_state = BTNodeState.RUNNING

func cancel():
	_state = BTNodeState.CANCEL

# You can use the following to recover the state of the node
func succeeded() -> bool:
	return _state == BTNodeState.SUCCESS

func failed() -> bool:
	return _state == BTNodeState.FAILURE

func running() -> bool:
	return _state == BTNodeState.RUNNING

func canceled() -> bool:
	return _state == BTNodeState.CANCEL


# Or this, as a string.
func get_state() -> String:
	if succeeded():
		return "success"
	elif failed():
		return "failure"
	else:
		return "running"

# Again, DO NOT override this. 
func tick(agent: Node, blackboard: Blackboard) -> void:
	if not is_active:
		fail()
		return
	
	if running():
		fail()
		return
	
	if debug:
		print(name)
	self.agent = agent
	self.blackboard = blackboard
	
	# Do stuff before core behavior
	_pre_tick(agent, blackboard)
	
	run() 
	
#	assert(running(), "BTNode execution was suspended but it's not running. Did you succeed() or fail() before yield?")
	_tick(agent, blackboard)
#	assert(not running(), "BTNode execution was completed but it's still running. Did you forget to return succeed() or fail()?") 
	
#	_post_tick(agent, blackboard, result)
	
	# Notify completion and new state (i.e. the result of the execution)
	
	# Queue tree abortion at the end of current tick
	if abort_tree:
		emit_signal("tree_aborted")

func _state_getter() -> int:
	return _state

func _on_ticked(result : bool):
	# Do stuff after core behavior depending on the result	
	_post_tick(agent, blackboard, result)
