extends Node
class_name AbilityManager

signal pre_damage_cause
signal pre_damage_receive
signal post_damage_cause
signal post_damage_receive

var _attribute_set : Dictionary = {}
var _abilities : Dictionary = {}
var _buffs : Array = []

######################################
#    Attribute
######################################

func initialize_attribute_set_by_config(attribute_set_config : AttributeSetConfig):
	"""
	通过Config初始化
	"""
	assert(attribute_set_config != null) 
	for i in range(0, attribute_set_config.attributes.size()):
		var attribute_data : AttributeConfig = attribute_set_config.attributes[i]
		var base_value = attribute_set_config.attribute_base_values[i]
		var growth_value = attribute_set_config.attribute_growth_values[i]
		var attribute = add_attribute_by_config(attribute_data, base_value, growth_value)
		_attribute_set[attribute_data.attribute_variable_name] = attribute
		
func add_attribute(attribute_name : String, base_value : int, growth_value : int = 0) -> AbilityAttribute:
	"""
	添加属性
	"""
	if attribute_name in _attribute_set.keys():
		return _attribute_set[attribute_name]
	var attribute_data = _get_attribute_data(attribute_name)
	return add_attribute_by_config(attribute_data, base_value, growth_value)

func add_attribute_by_config( attribute_config : AttributeConfig, base_value : int, growth_value : int = 0) -> AbilityAttribute:
	"""
	通过配置添加属性
	"""
	var attribute : AbilityAttribute = AbilityAttribute.new()
#	attribute.set_owner_attribute_set(self)
	assert(attribute_config != null && attribute_config is AttributeConfig)
	attribute.initialize_by_config(attribute_config, null)
	attribute.base_value = base_value
	attribute.growth_value = growth_value
	_attribute_set[attribute_config.attribute_variable_name] = attribute
	return attribute

func get_attribute(attribute_name : String) -> AbilityAttribute:
	if not _attribute_set.has(attribute_name) : return null
	return _attribute_set[attribute_name]
	
func _get_attribute_data(attribute_name : String) -> Resource:
	var data_path : String = "res://script/configs/attributes/" + attribute_name + ".tres"
	var attribute_data : AttributeConfig
	if(ResourceLoader.exists(data_path)):
		attribute_data = load(data_path)
	else:
		attribute_data = AttributeConfig.new()
		attribute_data.attribute_name = attribute_name
		attribute_data.attribute_variable_name = attribute_name
	return attribute_data

######################################
#    Ability
######################################

func get_ability(ability_name : String) -> AbilityBase:
	return _abilities[ability_name]

func try_active_ability(ability : AbilityBase, target : AbilityManager) -> void:
	ability.try_active(target)

func create_ability_by_config(ability_config : AbilityConfig) -> AbilityBase:
	var ability : AbilityBase = AbilityBase.new()
	ability.initialize_by_config(ability_config, self)
	return ability

func give_ability_by_config(ability_config : AbilityConfig ):
	var ability : AbilityBase = create_ability_by_config(ability_config)
	give_ability(ability)

func give_ability(ability : AbilityBase):
#	var ability : AbilityBase = AbilityBase.new()
#	ability.initialize_by_config(ability_config, self)
	_abilities[ability.ability_name] = ability
	add_child(ability)
	return ability

######################################
#    Effect
######################################

func apply_effect_by_config_name(effect_id : String, target : AbilityManager) -> AbilityEffect:
	var effect_config : AbilityEffectConfig = AbilityEffectConfig.new()
	effect_config.initialize_by_data_name(effect_id)
	return apply_effect_by_config(effect_config, target)

func apply_effect_by_config(effect_config : AbilityEffectConfig, target : AbilityManager) -> AbilityEffect:
	var effect : AbilityEffect
	match effect_config.effect_type:
		AbilityEffectConfig.EFFECT_TYPE.damage:
			effect = AbilityDamageEffect.new()
		AbilityEffectConfig.EFFECT_TYPE.attribute_modifier:
			effect = AttributeModifierEffect.new()
			effect.attribute = target.get_attribute(effect_config.args[0])
			effect.attribute_modifier.attribute_value = effect_config.args[1].to_int()
		_:
			assert(false)
	effect.initialize_by_config(effect_config, self, target)
	target.add_child(effect)
	return effect

######################################
#    Buff
######################################

func apply_buff_by_config(buff_config : BuffConfig, target: AbilityManager) -> AbilityBuff:
	var buff : AbilityBuff = AbilityBuff.new()
	buff.initialize_by_config(buff_config, self, target)
	target.add_buff(buff)
	return buff

func add_buff(buff : AbilityBuff) -> void:
	add_child(buff)
	self._buffs.append(buff)

func remove_buff(buff : AbilityBuff) -> void:
	self._buffs.erase(buff)
	remove_child(buff)
