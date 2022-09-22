extends System
class_name AIInputSystem

func _init():
	system_name = "S_AIInput"
	requirements = ["C_AIInput"]

static func get_random_position(entity : Entity) -> Vector2:
	randomize()
	var pos := Vector2(randf_range(0,50), randf_range(0,50))
	return pos
