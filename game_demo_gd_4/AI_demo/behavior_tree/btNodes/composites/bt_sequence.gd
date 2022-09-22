extends BTComposite
class_name BTSequence

func run() -> void:
	run_current_child_node()

func _on_child_completed(result : bool) -> void:
	if result != true:
		current_child_node = 0
		completed.emit(fail())
		return
	else:
		var ok := run_current_child_node()
		if not ok:
			completed.emit(succeed())
			return
