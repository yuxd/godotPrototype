extends Resource
class_name AttributeConfig

@export var attribute_name : String = ""
@export var attribute_describe : String = ""
@export var attribute_variable_name : String = ""
@export var is_percentage : bool = false # 是否为万分比参数，关系到界面显示
@export var max_value : int = -1 # -1 表示 没有上限
@export var min_value : int = 0

func initialize_by_data_name(attribute_name:String) -> void:
	var data = GameInstance.get_datatable_row(GameInstance.datatables.attribute, attribute_name)
	initialize_by_data(data)

func initialize_by_data(data : Dictionary) -> void:
	attribute_name = data["attribute_name"]
	attribute_describe = data["attribute_describe"]
	attribute_variable_name = data["attribute_variable_name"]
	is_percentage = data["is_percentage"].to_int()
	max_value = data["max_value"].to_int()
	min_value = data["min_value"].to_int()
