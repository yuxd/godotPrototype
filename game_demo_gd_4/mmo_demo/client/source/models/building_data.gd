extends Resource
class_name BuildingData


enum BUILDING_TYPE{ main_house,logging_yard,fishing_ground,
	quarry,mine,farmland,mage_tower,forging_house,shooting_range,
	leather_shop,tailor_shop,jewelry_store,inscription_store,herbalists,
	corra,planetarium,pub,wharf,
	}

@export var building_name : String = ""
@export var building_type : BUILDING_TYPE = BUILDING_TYPE.main_house
@export var building_time : int = 10 # 单位：s
@export var building_level :int = 1 # 建筑等级
@export var building_icon : Texture

func initialize_by_config(data : Dictionary):
	if data.is_empty():
		return
	building_name = data["building_name"]
	building_type = data["building_type"].to_int()
	building_time = data["building_time"]
	building_level = data["building_level"]
	if ResourceLoader.exists(data["building_icon"]):
		building_icon = load(data["building_icon"])
