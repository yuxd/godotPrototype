extends Node
class_name AbilityEffect

# 战斗行动概念，造成伤害、治疗英雄、赋给效果等属于战斗行动，需要继承自CombatAction
# 战斗行动由战斗实体主动发起，包含本次行动所需要用到的所有数据，并且会触发一系列行动点事件

var effect_config : AbilityEffectConfig = AbilityEffectConfig.new()
var effect_type : int = -1
var _creator 
var _target

func _ready():
	apply_action()
	post_apply_action()

func initialize_by_config(ability_effect_config : AbilityEffectConfig, creator, target):
#	self.effect_config = abiltiy_effect_config.duplicate(true)
	self.effect_config = ability_effect_config
	self._creator = creator
	self._target = target

func apply_action():
	pass

func disapply_action():
	queue_free()

func post_apply_action():
	assert(effect_config != null and _creator != null)
	if not effect_config.effects.size() <= 0:
		for child_effect_config in effect_config.effects:
			var _effect = _creator.apply_effect_by_config_name(child_effect_config, _target)
#	queue_free()
