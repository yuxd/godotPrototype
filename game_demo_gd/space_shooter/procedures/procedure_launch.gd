extends ProcedureBase

func enter(_msg := {}) -> void:
	print("enter")

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	state_machine.transition_to("preload")
