extends System
class_name RefreshSystem

func _init():
	system_name = "S_Refresh"
	requirements = ["C_Refreshable", "C_Prescene"]


func _system_process(_entities: Array, delta: float) -> void:
	for e in _entities:
		var refreshable : RefreshableComponent = e.get_component("C_Refreshable")		
		if refreshable.time_left <= 0:
			# 刷新逻辑
			active_refresh(e)
			refreshable.time_left == refreshable.refresh_inverval
		else :
			# 减时间逻辑
			refreshable.time_left = refreshable.time_left - delta


func active_refresh(ref_entity : Entity) -> void:
	var ref : RefreshableComponent = ref_entity.get_component("C_Refreshable")
	var prescene : PresceneComponent = ref_entity.get_component("C_Prescene")
	if ref.can_refresh():
		var sub = ref.get_random_subordinate().instantiate()
		ref.subordinates.append(sub)
		sub.position = ref_entity.position + ref.get_refresh_position()
		prescene.owner_scene.add_child(sub)
