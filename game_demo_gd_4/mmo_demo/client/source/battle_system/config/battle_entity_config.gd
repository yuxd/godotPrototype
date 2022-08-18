extends Resource
class_name BattleEntityConfig

@export var entity_name :String= ""
@export var attribute_set_config : Resource
@export var abilities : Array = []

func initialize_by_config(data : Dictionary) -> void:
	if data.is_empty():
		printerr("can not initialeze by config!")
		return
	entity_name = data["entity_name"]
	attribute_set_config = AttributeSetConfig.new()
	var attribute_set_data = data["attribute_set"].split("*")
	for i in attribute_set_data.size():
		if i % 3 == 0:
			var attribute_name = attribute_set_data[i].dedent()
			var attribute_config = AttributeConfig.new()
			attribute_config.initialize_by_data_name(attribute_name)
			attribute_set_config.attributes.append(attribute_config)
		elif i % 3 == 1:
			attribute_set_config.attribute_base_values.append(attribute_set_data[i].dedent().to_int())
		elif i % 3 == 2:
			attribute_set_config.attribute_growth_values.append(attribute_set_data[i].dedent().to_int())
#	attribute_set_config.initialize_by_config(attribute_set_config)
	for ability_str in data["abilities"].split("*"):
		var ability_config = AbilityConfig.new()
		var ability_data = GameInstance.get_datatable_row(GameInstance.datatables.abilities, ability_str.dedent())
		ability_config.initialize_by_config(ability_data)
		abilities.append(ability_config)
