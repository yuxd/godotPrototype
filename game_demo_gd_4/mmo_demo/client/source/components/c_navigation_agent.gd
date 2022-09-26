extends NavigationAgent2D
class_name NavigationAgentComponent

const component_name = "C_NavigationAgent"


func _ready() -> void:
	set_target_location(owner.position + Vector2(0,0))


#func _process(delta: float) -> void:
#	if not get_nav_path().is_empty():
#		printerr("=========>", get_nav_path())


func _physics_process(delta: float) -> void:
	get_next_location()
