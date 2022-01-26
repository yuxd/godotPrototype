extends Node

const datatable_manager_class = preload("res://addons/QFramework/datatable/csv_datatable_manager.gd")
const procedure_manager_class = preload("res://addons/QFramework/procedure/manager_procedure.gd")

var _datatable_manager : DatatableManager
var _procedure_manager : ProcedureManager
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_datatable_manager() -> DatatableManager:
	if !_datatable_manager:
		_datatable_manager = datatable_manager_class.new()
		self.add_child(_datatable_manager)
	return _datatable_manager

func get_procedure_manager() -> ProcedureManager:
	if !_procedure_manager:
		_procedure_manager = procedure_manager_class.new()
		self.add_child(_procedure_manager)
	return _procedure_manager
