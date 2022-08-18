extends Node

var ui_manager : UIManager
var game_main : GameMode

var player_character : Entity

func _enter_tree():
	pass
	
func _ready():
	init_qramework()
	
func init_qramework():
	ui_manager = QInstance.ui_manager
	ui_manager.init_ui_manager(Globals.widget_path, Globals.widget_path)

func create_player_character():
	player_character = create_entity("player_character")

func create_building(building_id : String) -> Entity:
	var building : Entity = load("res://entities/building.tscn").instantiate()
	game_main.add_child(building)	
	var building_data = get_datatable_row(data_model.building, building_id)
	var building_res : BuildingData = BuildingData.new()
	building_res.initialize_by_config(building_data)
	var c_building : BuildingComponent = building.get_component(components.building)
	c_building.building_data = building_res
	building.name = building_id
	return building

func print_action(msg : String) -> void:
	print_debug(msg)

class components:
	const building := "c_building"
	const inventory := "c_inventory"
	const inventory_item := "c_inventory_item"
	const quest := "c_quest"

class data_model:
	const model_path := "res://script/model/"
	
	const abilities : String = "abilities"
	const attribute : String = "attribute"
	const ability_effects : String = "ability_effects"
	const battle_configs : String = "battle_configs"
	const buffs : String = "buffs"
	const enemy : String = "enemy"
	const battle_entities = "battle_entities"
	const building := "building"
	const quest := "quest"
	
	# 这个 dic 决定哪些 datatable 初始加载
	const datatables : Array = [
		abilities,
		ability_effects,
		battle_configs,
		buffs,
		enemy,
		battle_entities,
		building,
		quest,
	]
	
	const resource_path : Dictionary = {
		quest : model_path + "quest_data" + ".gd"
	}

class attributes:
	extends Object
	const max_health : String = "max_health"
	const attack_interval : String = "attack_interval"
	const defen_power : String = "defen_power"
	const attack_power : String = "attack_power"
	
	const current_health : String = "current_health"

static func get_datatable_row(datatable_name : String, row_id : String) -> Dictionary:
	var datatable : Dictionary = QInstance.datatable_manager.get_datatable(datatable_name)
	if datatable.is_empty() or row_id == "": return {}
	return datatable[row_id]

static func get_component_path(component_name : String):
	return Globals.component_path + component_name + ".gd"

static func create_res_by_data(gd_script : GDScript, datatable : String, data_row : String) -> Resource:
	var res : Resource = gd_script.new()
	if res.has_method("initialize_by_config"):
		var data = Globals.get_datatable_row(datatable, data_row)		
		res.initialize_by_config(data)
	return res

static func create_resource(resource_name : String, data_row : String) -> Resource:
	assert(ResourceLoader.exists(Globals.data_model.resource_path[resource_name]))
	var res_script : GDScript = load(Globals.data_model.resource_path[resource_name])
	var res = create_res_by_data(res_script, resource_name, data_row)
	return res

static func load_datatables(datatables : Array) -> void:
	await QInstance.datatable_manager.load_datatables_async(datatables)

static func create_entity(entity_name : String) -> Entity:
	var entity_path := Globals.entity_path + entity_name + ".tscn"
	assert(ResourceLoader.exists(entity_path))
	var entity_scene : PackedScene =  ResourceLoader.load(entity_path)
	var entity : Entity = entity_scene.instantiate()
	GameInstance.game_main.add_child(entity)
	return entity
	
static func create_order() -> void:
	var order = Node.new()
	GameInstance.game_main.order_group.add_child(order)
