extends ProcedureBase
class_name ProcedureLaunch

var state_name := "procedure_launch"

func enter(_msg := {}) -> void:
	print_debug(" procedure launch enter")
	state_machine.transition_to("procedure_load_resource")
