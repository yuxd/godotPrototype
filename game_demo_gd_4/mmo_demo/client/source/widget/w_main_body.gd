extends MarginContainer

@onready var tc_main : TabContainer = $tc_main

func set_tc_main(index : int):
	tc_main.current_tab = index
