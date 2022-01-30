extends ProcedureBase
class_name ProcedureMenu

var _start_game : bool = false

func enter(_msg := {}) -> void:
	QInstance.get_UI_manager().show_form("res://UI/UI_menu_form.tscn")

func update(_delta: float) -> void:
	if _start_game:
		var msg = {}
		msg["_change_to_menu"] = false
		state_machine.transition_to("change_scene",msg)

func start_game() -> void:
	_start_game = true

func exit() -> void:
	pass

