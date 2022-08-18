extends AbilityEffect
class_name AbilityDamageEffect

var formula : String = ""
var damage_value : int = 0

func apply_action():
	apply_damage()

func pre_process() -> void:
#	damage_value = parse(formula)
	_creator.emit_signal("pre_damage_cause", _target, self)
	_target.emit_signal("pre_damage_receive", _target, self)
	
func apply_damage() -> void:
#	if not "receive_damage" in _target:
#		printerr("cannot found receive_damage in: ", _target)
	pre_process()
	damage_value = _creator.get_attribute("attack_power").value - _target.get_attribute("defen_power").value
	var current_health : AbilityAttribute = _target.get_attribute(GameInstance.attributes.current_health)
	current_health.base_value = current_health.base_value - damage_value
	post_process()

func post_process() -> void:
	_creator.emit_signal("post_damage_cause", _target, self)
	_target.emit_signal("post_damage_receive", _creator, self)
	var action_str : String = _target.owner.name + " 受到伤害：" + str(damage_value) + " 来自： " + _creator.owner.name + " 当前生命值： " + str(_target.get_attribute(GameInstance.attributes.current_health).value)
	GameInstance.print_action(action_str)
