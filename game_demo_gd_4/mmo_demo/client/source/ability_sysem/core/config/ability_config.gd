extends Resource
class_name AbilityConfig

enum TARGET_TYPE{ none, oneself, all, friendly_single, enemy_single, 
	friendly_multiple, enemy_multiple, friendly_all, enemy_all}

@export var ability_name : String
@export var ability_descript : String
@export var ability_icon : Texture
@export var is_passive : bool = false
@export var condition_id : PackedStringArray
@export var cost_type : int
@export var cost_args : PackedStringArray
@export var cool_down_time : int
@export var target_type : TARGET_TYPE = TARGET_TYPE.none
@export var target_args : PackedStringArray = [1]
@export var tasks : PackedStringArray
@export var effects : Array = []

func initialize_by_config(data: Dictionary) -> void:
	ability_name = data["ability_name"]
	ability_descript = data["ability_descript"]
	if ResourceLoader.exists(data["ability_icon"]):
		ability_icon = load(data["ability_icon"])
	else:
		ability_icon = null
	is_passive = data["is_passive"].to_int()
	condition_id = data["condition_id"].split("*")
	cost_type = data["cost_type"].to_int()
	cost_args = data["cost_args"].split("*")
	cool_down_time = data['cool_down_time'].to_int()
	target_type = data["target_type"].to_int()
	target_args = data["target_args"].split("*")
	tasks = data["tasks"].split("*")
	for item in data["effects"].split("*"):
		var effect_config : AbilityEffectConfig = AbilityEffectConfig.new()
		effect_config.initialize_by_data_name(item)
		effects.append(effect_config)
