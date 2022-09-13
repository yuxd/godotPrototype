extends System
class_name PlayerInputSystem

func _init():
	system_name = "S_PlayerInput"
	requirements = ["C_Input", "C_Player"]
	tps = Globals.INPUT_TPS
	
func _system_process(entities: Array, _delta : float) -> void:
	for e in entities:
		var inputs: Array = e.get_components("C_Input")
		for input in inputs:
			update_input_state(input)
#			printerr(input)

static func update_input_state(input: InputComponent) -> void:
	input.history.append(input.state.duplicate())
	if input.history.size() > input.max_history:
		input.history.pop_front()
	input.state[Globals.InputAction.MOVE_UP] = Input.is_action_pressed("ui_up")
	input.state[Globals.InputAction.MOVE_DOWN] = Input.is_action_pressed("ui_down")
	input.state[Globals.InputAction.MOVE_LEFT] = Input.is_action_pressed("ui_left")
	input.state[Globals.InputAction.MOVE_RIGHT] = Input.is_action_pressed("ui_right")
#	input.state[Globals.InputAction.JUMP] = Input.is_action_pressed("jump")
	input.state[Globals.InputAction.CAMREA_ZOOM_UP] = Input.is_action_pressed("camera_zoom_up")
	input.state[Globals.InputAction.CAMREA_ZOOM_DOWN] = Input.is_action_pressed("camera_zoom_down")
