extends Node
class_name QFramework

var datatable_manager : DatatableManager = null 
var scene_manager : SceneManager 
var ui_manager : UIManager 
var res_loader : ResourceAsyncLoader 
var config = ConfigFile.new()
#var main_screne = null

var player_character = null : set = set_player_character, get = get_player_character
var player_controller = null : set = set_player_controller, get = get_player_controller
var current_scene = null
var main_node = null
var camera  = null

signal change_player_character(player)
signal change_player_controller(controller)

func _enter_tree():
	pass

func _ready():
	ui_manager = get_node("UIManager")		
	res_loader = get_node("ResourceAsyncLoader")
	scene_manager = get_node("SceneManager")
	datatable_manager = get_node("CSVDatatableManager")

func get_res_loader() -> ResourceAsyncLoader:
	if !res_loader:
		res_loader = ResourceAsyncLoader.new()
		self.add_child(res_loader)
	return res_loader

func set_player_character(player):
	self.emit_signal("change_player_character",player)
	player_character = player

func get_player_character():
	return player_character
		
func set_player_controller(controller):
	self.emit_signal("change_player_controller",controller)
	self.add_child(controller)
	player_controller = controller

func get_player_controller():
	return player_controller
		
static func is_component(node: Node) -> bool:
	return true if node.get("component_name") else false

static func is_entity(node: Node) -> bool:
	return node.is_in_group("Entity")

static func is_system(node: Node) -> bool:
	return true if node.get("system_name") else false

static func matches_entity_filter(entity: Node, filter: Array) -> bool:
	var entity_class: String = entity.get_class()
	if not entity_class in filter or "!%s" % entity_class in filter:
		return false
	return true
	
