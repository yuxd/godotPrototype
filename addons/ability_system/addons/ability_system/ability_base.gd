###############技能模型########################
#继承此脚本用以创建新的技能
#需要你初始化的变量 skill_id ， skill_level
#需要你重新实现的函数：
#    _replace_skill_var 
##############################################
extends Node
class_name AbilityBase
###########以下成员继承后需要子类进行初始化#################
onready var skill_id:String = "x"
onready var skill_level:int  = 0

#技能面板上展示的技能名称
func _get_skill_title() -> String:
    return AbilityDataBase.get_ability_arg("name",skill_id) + "(LV" + String(skill_level) + ")"
    pass

#如果你的技能描述中存在变量,例如 ： 造成 {base_damage} 物理伤害
#则你必须重写此函数 将_skill_raw_desp 中的 变量 {base_damage} 替换为此技能的实际数值
#默认的实现仅仅返回参数而不做任何事
#func _replace_skill_var(_skill_raw_desp : String) ->String:
#     return _skill_desp.format({"base_damage":20})
func _replace_skill_var(_skill_raw_desp : String) ->String:
    return _skill_raw_desp
    pass


func get_desp_string() -> String:
    var raw_desp:String =  AbilityDataBase.get_ability_arg("desp", skill_id)
    return _replace_skill_var(raw_desp)
    pass


#计算技能影响乘区 请根据技能伤害逻辑在子类中实现伤害计算
func _get_skill_damage() -> float :
    return 0.0

#如果是需要选中目标的技能 则返回最大目标数
func _get_skill_target_count() -> int :
    return 0
