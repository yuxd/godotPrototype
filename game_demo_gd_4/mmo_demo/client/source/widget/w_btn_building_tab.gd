extends TextureButton

@onready var img_building_icon : TextureRect = $MarginContainer/HBoxContainer/img_building_icon
@onready var lab_building_name : Label = $MarginContainer/HBoxContainer/lab_buidling_name

func _ready():
	pass
	
func init_button(building_data : BuildingData):
	img_building_icon.texture = building_data.building_icon
	lab_building_name.text = building_data.building_name
