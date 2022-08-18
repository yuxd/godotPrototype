extends MarginContainer

#@onready var btn_main_building := $hb/mc/sc/vc/btn_main_building
#@onready var btn_logging := $hb/mc/sc/vc/btn_logging
@onready var vb_building_tab_bar := $hb/mc/sc/vb_building_tab_bar
@onready var tc_buildings : TabContainer = $hb/tc_buildings

func _ready():
	vb_building_tab_bar.connect("tab_changed", _on_vb_building_tab_bar_tab_changed)
	pass

func _on_vb_building_tab_bar_tab_changed(tab: int):
	tc_buildings.current_tab = tab
	print_debug(tab)
