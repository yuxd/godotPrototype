extends System
class_name RefreshSystem

func _init():
	system_name = "S_Refresh"
	requirements = ["C_Refreshable"]


func _system_process(_entities: Array, delta: float) -> void:
	for e in _entities:
		var refreshable : RefreshableComponent = e.get_component("C_Refreshable")
		if refreshable.time_left <= 0:
			# 刷新逻辑
			var new_c = active_refresh(refreshable)
			refreshable.time_left == refreshable.refresh_inverval
		else :
			# 减时间逻辑
			refreshable.time_left = refreshable.time_left - delta


func active_refresh(ref : RefreshableComponent) -> Entity:
	if ref.can_refresh():
		var sub = ref.get_random_subordinate().instantiate()
		ref.subordinates.append(sub)
		return sub
	return null
