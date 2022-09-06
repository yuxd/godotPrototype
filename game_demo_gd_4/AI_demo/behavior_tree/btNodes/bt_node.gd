extends Node
class_name BTNode

enum BTState {
	SUCCESS,
	FAIL,
	RUNNING,
	CANCELED
}

signal completed
var _state : BTState = BTState.CANCELED

func succeed() -> bool:
	_state = BTState.SUCCESS
	return true
	
func fail() -> bool:
	_state = BTState.FAIL
	return false
	
func run() -> void:
	_state = BTState.RUNNING

func cancel() -> void:
	_state = BTState.CANCELED

func is_successed() -> bool:
	return _state == BTState.SUCCESS
