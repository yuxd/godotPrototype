extends AttributeSetBase
class_name BattleAttributeSet

func pre_value_change(attribute : AbilityAttribute, value : int) -> int:
	var max_health = get_attribute(GameInstance.attributes.max_health)
	var current_health = get_attribute(GameInstance.attributes.current_health)
	if attribute == current_health:
		if value >= max_health.value:
			return max_health.value
		elif value < 0:
			return 0
	return value

func post_value_changed(attribute : AbilityAttribute, value : int) -> void:
	var max_health = get_attribute(GameInstance.attributes.max_health)
	var current_health = get_attribute(GameInstance.attributes.current_health)
	if attribute == current_health:
		if value <= 0:
			_owner_ability_manager.die()
