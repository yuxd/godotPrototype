extends RefCounted
class_name AbilityAttribute

enum ModifierType{ add, pct_add, final_add, final_pct_add }

var attribute_data : AttributeConfig = null

var value : int = 0
var base_value : int = 0 :
	set = _base_value_setter
var growth_value : int = 0 

var add_value : int = 0
var pct_add_value : int = 0
var final_add_value : int = 0
var final_pct_add_value : int = 0

var add_collector : AttributeModifierCollector = AttributeModifierCollector.new()
var pct_add_collector : AttributeModifierCollector = AttributeModifierCollector.new()
var final_add_collector : AttributeModifierCollector = AttributeModifierCollector.new()
var final_pct_add_collector : AttributeModifierCollector = AttributeModifierCollector.new()

signal value_changed(modifier_type, attribute_modifier)

var _attribute_owner = null

func initialize_by_config(attribute_data : AttributeConfig, attribute_owner) -> void:
	self.attribute_data = attribute_data
	_attribute_owner = attribute_owner

func add_modifier( modifier_type, attribute_modifier : AttributeModifier) -> void:
#	_attribute_owner.pre_add_modifier(self, modifier_type, attribute_modifier)
	match modifier_type:
		ModifierType.add:
			add_value = add_collector.add_modifier(attribute_modifier)
		ModifierType.pct_add:
			pct_add_value = pct_add_collector.add_modifier(attribute_modifier)
		ModifierType.final_add:
			final_add_value = final_add_collector.add_modifier(attribute_modifier)
		ModifierType.final_pct_add:
			final_pct_add_value = final_pct_add_collector.add_modifier(attribute_modifier)
		_:
			printerr("cannot found modifier type, to add modifier")			
			return
	update_value()
#	_attribute_owner.post_add_modifier(self, modifier_type, attribute_modifier)

func remove_modifier( modifier_type, attribute_modifier : AttributeModifier) -> void:
#	_attribute_owner.pre_remove_modifier(self, modifier_type, attribute_modifier)	
	match modifier_type:
		ModifierType.add:
			add_value = add_collector.remove_modifier(attribute_modifier)
		ModifierType.pct_add:
			pct_add_value = pct_add_collector.remove_modifier(attribute_modifier)
		ModifierType.final_add:
			final_add_value = final_add_collector.remove_modifier(attribute_modifier)
		ModifierType.final_pct_add:
			final_pct_add_value = final_pct_add_collector.remove_modifier(attribute_modifier)
		_:
			printerr("cannot found modifier type, to remove modifier")
			return
	update_value()
#	_attribute_owner.post_remove_modifier(self, modifier_type, attribute_modifier)

func update_value():
	var value1 = base_value;
	var value2 = (value1 + add_value) * (10000 + pct_add_value) / 10000;
	var value3 = (value2 + final_add_value) * (10000 + final_pct_add_value) / 10000;
	if _attribute_owner and _attribute_owner.has_method("pre_value_change"):
		var new_value = _attribute_owner.pre_value_change(self, value3)
		value = new_value
	else:
		value = value3
	emit_signal("value_changed", value)
	if _attribute_owner and _attribute_owner.has_method("post_value_changed"):
		_attribute_owner.post_value_changed(self, value)

func _base_value_setter(value):
	if _attribute_owner and _attribute_owner.has_method("pre_base_value_changed"):
		var new_value = _attribute_owner.pre_base_value_changed(self, value)
		base_value = new_value		
	else:
		base_value = value
	update_value()
	if _attribute_owner and _attribute_owner.has_method("post_base_value_changed"):
		_attribute_owner.post_base_value_changed(self, value)	
