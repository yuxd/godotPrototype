extends Resource
class_name AbilityEffectConfig

enum EFFECT_TYPE { 
	damage,
	attribute_modifier,
	treatment,
	none 
}

@export var effect_type : EFFECT_TYPE = EFFECT_TYPE.none
@export var args : PackedStringArray = []
@export var effects : Array = []

func initialize_by_data_name(data_name : String):
	var data := GameInstance.get_datatable_row(GameInstance.datatables.ability_effects, data_name)
	initialize_by_data(data)

func initialize_by_data(data : Dictionary):
	if data.is_empty():
		printerr("effect data is empty!")
		return
	effect_type = data["effect_type"].to_int()
	args = data["args"].split("*")
	if data["effects"] == "":
		effects = []
	else:
		effects = data["effects"].split("*")
	# for item in data["effects"].split("*"):
	# 	var effect_config = AbilityEffectConfig.new()
	# 	effect_config.initialize_by_data_name(item)
	# 	effects.append(effect_config)
