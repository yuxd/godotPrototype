extends Node

var _datatable_manager : DatatableManager

# Called when the node enters the scene tree for the first time.
func _ready():
	_datatable_manager = CSVDatatableManager.new()
	self.add_child(_datatable_manager)
	_datatable_manager.set_datatable_path("res://datatables/")
	var d = _datatable_manager.get_datatable("Aircraft")
	print(d)

func get_datatable_manager() -> DatatableManager:
	if !_datatable_manager:
		_datatable_manager = CSVDatatableManager.new()
		self.add_child(_datatable_manager)
	return _datatable_manager
