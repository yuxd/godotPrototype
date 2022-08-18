extends System
class_name BuildingSystem

func _init():
	system_name = "S_Building"
	requirements = ["C_Building"]

func _system_ready():
	print_debug("s_building, _system_ready")
