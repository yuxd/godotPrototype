extends Node
class_name AttributeModifierCollector

var total_value : int
var _modifiers : Array = []

signal modifier_added(modifier)
signal modifier_removed(modifier)

func add_modifier(modifier : AttributeModifier) -> int:
	_modifiers.append(modifier)
	update_modifiers()
	emit_signal("modifier_added",modifier)
	return total_value
	
func remove_modifier(modifier : AttributeModifier) -> int:
	_modifiers.erase(modifier)
	update_modifiers()
	emit_signal("modifier_removed",modifier)
	return total_value
	
func update_modifiers():
	total_value = 0
	for item in _modifiers:
		if item is AttributeModifier:
			total_value += item.attribute_value
