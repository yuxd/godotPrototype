extends Node
# class_name AbilityDataBase

var abilities:Dictionary = {}

func _ready():
    init_ability_dic()

func init_ability_dic():
    #在此处初始化技能信息， 可以从其他数据库，excel等载体中读取，此处为了示例直接写在代码里
    #请这些技能信息：并非完整的数值信息和伤害逻辑
    abilities = {        #id
                    "skill_0000001":{        
                    #最大等级
                    "max_leve": 20,
                    #名称
                    "name":"普通射击",
                    #描述 体现你的伤害逻辑
                    "desp":"对目标位置进行射击， 造成 {base_damage} 物理伤害，如果目标处于眩晕、虚弱、减速等移动受限状态，则伤害提高 {ext_increment}%",
                    #等级提升所需消耗 此处只消耗一项经验值 可以自行扩展为字典，用以消耗多个资源
                    "leve_up_cost": [10,10,10,20,20,20,30,30,50,50,100,100,100,150,150,150,200,300,400]
                },

                "skill_0000002":{
                    #最大等级
                    "max_leve": 30,
                    #名称
                    "name":"精准射击",
                    #描述
                    "desp":"花费时间对这一击精心准备，短暂延迟后，对目标进行精确打击，造成 {base_damage} + {ext_incremnt}%额外物理伤害{damage_out} 此攻击无视目标闪避率",
                    #等级提升所需消耗 此处只消耗一项经验值 可以自行扩展为字典，用以消耗多个资源
                    "leve_up_cost": [10,10,10,20,20,20,30,30,50,50,100,100,100,150,150,150,200,300,400]        
                }
            }

func get_ability_arg(arg_name:String, id:String) :
    return abilities[id][arg_name]