extends AbilityBase

var base_damage :=  0.0
var target_state := "眩晕"

func _ready():
	skill_id = "skill_0000001"
	skill_level = 1
	pass


#计算技能影响乘区 请根据技能伤害逻辑在子类中实现伤害计算
#"对目标位置进行射击， 造成 {base_damage} 物理伤害，如果目标处于眩晕、虚弱、减速等移动受限状态，则伤害提高 {ext_increment}%",
func _get_skill_damage() -> float :
	base_damage = calc_base_damage() #此处可计算其他逻辑 比如伤害加成 什么的。。。。

	#注意 由于只演示技能系统 因此代码与其他系统交互存在不完善， 如此处 ["眩晕","减速","虚弱"] 仅仅是示例， 
	#应该提供一个函数返回所有 移动受限状态
	#且 target_state 应由战斗系统给出 此处仅做示例！！
	if ["眩晕","减速","虚弱"].has(target_state) :
		base_damage += base_damage * calc_ext_increment() / 100.0 
	return 0.0

#如果你的技能描述中存在变量,例如 ： 造成 {base_damage} 物理伤害
#则你必须重写此函数 将 skill_var_list 中的 变量 {base_damage} 替换为此技能的实际数值
#默认的实现仅仅返回参数而不做任何事
#func _replace_skill_var(_skill_raw_desp : String) ->String:
#     return _skill_desp.format({"base_damage":20})
func _replace_skill_var(_skill_raw_desp : String) ->String:
	_skill_raw_desp.format({"base_damage":calc_base_damage()})
	_skill_raw_desp.format({"ext_increment":calc_ext_increment()})
	return _skill_raw_desp
	pass


#如果是需要选中目标的技能 则返回最大目标数
func _get_skill_target_count() -> int :
	#只演示最简单的情况
	match skill_level :
		1,5 :
			return 1
		6,20 :
			return 2

	return 0


func calc_base_damage() -> float:
	return skill_level * 15.0
func calc_ext_increment() -> float:
	return 20.0
