extends Node

const datatable_manager_class = preload("res://addons/QFramework/managers/datatable/csv_datatable_manager.gd")

var _datatable_manager : DatatableManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_datatable_manager() -> DatatableManager:
	if !_datatable_manager:
		_datatable_manager = datatable_manager_class.new()
		self.add_child(_datatable_manager)
	return _datatable_manager
