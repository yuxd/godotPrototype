extends VBoxContainer

signal tab_changed(index : int)

var btn_buildings = []

func _ready():
	for child in get_children():
		child.queue_free()
	var building_data : BuildingData = BuildingData.new()
	building_data.building_name = "测试"
	building_data.building_type = BuildingData.BUILDING_TYPE.leather_shop
	create_building_button(building_data)
	
func create_building_button(btn_data : BuildingData):
	var btn = load( Globals.widget_path + "w_btn_building_tab.tscn").instantiate()
	add_child(btn)
	btn.init_button(btn_data)
	btn.connect("pressed", _on_btn_pressed.bind(btn_data.building_type))
	
func _on_btn_pressed(index : int):
	emit_signal("tab_changed", index)
