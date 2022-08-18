extends Resource
class_name AttributeSetConfig

@export var attributes : Array
@export var attribute_base_values : PackedInt32Array
@export var attribute_growth_values : PackedInt32Array

func initialize_by_config(data :Dictionary):
	var attribute_names_str = data["attribute_names"].split("*")
	for item in attribute_names_str:
		var attribute_config = load("res://GDScript/Source/AbilitySysem/AttributeData/" + item + ".tres")
		attributes.append(attribute_config)
	var attribute_base_values_str = data["attribute_base_values"].split("*")
	for attribute_base_value in attribute_base_values_str:
		attribute_base_values.append(attribute_base_value.to_int())
	var attribute_growth_values_str = data["attribute_growth_values"].split("*")
	for attribute_growth_value in attribute_growth_values_str:
		attribute_growth_values.append(attribute_growth_value.to_int())
