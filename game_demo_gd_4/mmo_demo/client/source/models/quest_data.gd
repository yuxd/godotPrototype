class_name QuestData
extends Resource

enum active_condition_TYPE{
	get_item,
	use_item,
	level,
}

enum QUEST_TARGET_TYPE{
	none,
	logic,
	battle,
	item
}

@export var name : String = ""
@export var quest_type : String = ""
@export var slot : String = ""
@export var b_show : bool = true
@export var active_condition : PackedStringArray = []
@export var npc_id : String = ""
@export var target : PackedStringArray = [] # 任务目标
@export var deliver_npc_id : String = ""
@export var deliver_item : PackedStringArray = []
@export var award_id : String = ""
@export var follow_quest : String = ""
@export var events : PackedStringArray = []

