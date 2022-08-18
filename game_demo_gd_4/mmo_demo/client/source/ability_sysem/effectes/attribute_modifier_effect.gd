extends AbilityEffect
class_name AttributeModifierEffect

var attribute_modifier : AttributeModifier = AttributeModifier.new()
var attribute : AbilityAttribute

func apply_action():
	attribute.add_modifier(AbilityAttribute.ModifierType.add,attribute_modifier)

func disapply_action():
	attribute.remove_modifier(AbilityAttribute.ModifierType.add,attribute_modifier)
	queue_free()
