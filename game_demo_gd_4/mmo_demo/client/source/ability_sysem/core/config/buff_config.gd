extends Resource
class_name BuffConfig

enum DURATION_TYPE{immediately, permanent, durationTime}
enum TARGET_TYPE{ none, oneself, all, friendly_single, enemy_single, 
	friendly_multiple, enemy_multiple, friendly_all, enemy_all}
	
@export var buff_name : String
@export var buff_descript : String
@export var buff_icon : Texture
@export var can_stack : bool = false
@export var max_stack : int = 1
@export var duration_type : DURATION_TYPE = DURATION_TYPE.immediately
@export var duration_arg1 : int
@export var condition_id : String
@export var target_type : TARGET_TYPE= TARGET_TYPE.none
@export var target_arg1 : int = 1
@export var tasks : PackedStringArray
@export var effects : PackedStringArray
@export var follow_buff_condition_ids : PackedStringArray
@export var follow_buff_ids : PackedStringArray
