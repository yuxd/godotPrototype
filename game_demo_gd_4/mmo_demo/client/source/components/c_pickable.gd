extends Area2D
class_name PickableComponent

const component_name := "C_Pickable"
@export var pickup_radius := 15


func _on_pickable_component_body_entered(body):
	print_debug("_on_pickable_component_body_entered")


func _on_pickable_component_body_exited(body):
	print_debug("_on_pickable_component_body_exited")
