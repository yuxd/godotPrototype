# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state : NodePath
# The current active state. At the start of the game, we get the `initial_state`.
var current_state : Node = null
var states = {}

func _enter_tree() -> void:
	# The state machine assigns itself to the State objects' state_machine property.
	launch()

func add_state(state : Node) -> bool:
	if is_state(state):	
		self.add_child(state)
		states[state.state_name] = state
		if "state_machine" in state:
			state.state_machine = self
		return true
	return false
	
func has_state(state_name : String) -> bool:
	return true if states.has(state_name) else false
	
func set_initial_state(name) -> void:
	initial_state = states[name]

func launch() -> void:
	assert(initial_state)
	# 需要手动启动状态机
	current_state = get_node(initial_state)
	for child in get_children():
		if is_state(child):
			states[child.state_name] = child
			if "state_machine" in child:
				child.state_machine = self
	current_state.enter()

# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	if !current_state or not current_state.has_method("handle_input"):
		return
	current_state.handle_input(event)

func _process(delta: float) -> void:
	if !current_state or not current_state.has_method("update"):		
		return
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	if !current_state or not current_state.has_method("physics_update"):
		return
	current_state.physics_update(delta)

# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	assert(has_state(target_state_name) and current_state)
	if current_state.has_method("exit"):
		current_state.exit()
	current_state = states[target_state_name]
	if current_state.has_method("enter"):
		current_state.enter(msg)
	emit_signal("transitioned", target_state_name)

static func is_state(state : Node) -> bool:
	return true if "state_name" in state else false
