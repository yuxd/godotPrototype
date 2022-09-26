extends Node
class_name AbilityBase

var _ability_config : AbilityConfig = AbilityConfig.new()
var _owner_ability_manager
var target
var ability_name : String
#var need_target setget ,_need_target_getter

func initialize_by_config(ability_config : AbilityConfig, owner_ability_manager):
#	self._ability_config = ability_config.duplicate(true)
	self._ability_config = ability_config
	ability_name = _ability_config.ability_name
	_owner_ability_manager = owner_ability_manager

func try_active(ability_target) -> void:
	self.target = ability_target
	for effect_config in _ability_config.effects:
		if effect_config is AbilityEffectConfig:
			var _effect = _owner_ability_manager.apply_effect_by_config(effect_config, target)

#func _need_target_getter():
#	match ability_config.target_type:
#		ability_config.TARGET_TYPE.all:
#			return false
#		ability_config.TARGET_TYPE.enemy_all:
#			return false
#		ability_config.TARGET_TYPE.friendly_all:
#			return false
#		ability_config.TARGET_TYPE.enemy_single:
#			return true
#		ability_config.TARGET_TYPE.friendly_single:
#			return true
#		ability_config.TARGET_TYPE.oneself:
#			return false
#		ability_config.TARGET_TYPE.none:
#			return false
#		_:
#			return false
