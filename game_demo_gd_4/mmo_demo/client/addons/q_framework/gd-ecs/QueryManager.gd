class_name QueryManager
extends Node

var component_groups := {}
var system_manager: Node

func _init(_system_manager: Node) -> void:
	system_manager = _system_manager

func _ready() -> void:
	# warning-ignore: return_value_discarded
	connect("tree_exiting", _on_tree_exiting)
	var tree: SceneTree = get_tree()
	# warning-ignore: return_value_discarded
	tree.connect("node_added", _on_node_added)
	# warning-ignore: return_value_discarded
	tree.connect("node_removed", _on_node_removed)

# Returns an Array of all entities that have the components defined in query_list
# Assumes that the query_list is sorted
func query(query_list: Array, entity_filter := []) -> Array:
	var results := []
	var entity_list: Array = component_groups.get(query_list, [])
	for entity_id in entity_list:
		var entity: Node = instance_from_id(entity_id)
		if entity_filter:
			var entity_class: String = entity.get_class()
			if not entity_class in entity_filter or "!%s" % entity_class in entity_filter:
				continue
		results.append(entity)

	return results

# Goes through all the existing entities in the SceneTree and updates the local component_group cache
func ready() -> void:
	for entity in get_tree().get_nodes_in_group("Entity"):
		update_component_groups(entity)

func register_requirements(system_requirements: Array) -> void:
	# system_requirements must be sorted
	# component groups are just groups of different components as required by systems
	if not system_requirements in component_groups:
		var entity_list := []
		component_groups[system_requirements] = entity_list

# Update the component_group cache for a given entity. Adds/removes an entity from the cache depending on whether it meets the group's requirements.
# The number of unique component groups should be <= number of unique systems
func update_component_groups(entity: AbstractEntity) -> void:
	for component_group in component_groups:
		var entity_list: Array = component_groups[component_group]
		# TODO: keep the entity list sorted? for faster searching
		if entity.meets_requirements(component_group):
			if not entity.id in entity_list:
				entity_list.append(entity.id)
		else:
			entity_list.erase(entity.id)

func _on_node_added(node: Node) -> void:
	if ECS.is_component(node):
		var entity: AbstractEntity = node.get_parent()
		entity.register_component(node)
		update_component_groups(entity)
	elif ECS.is_entity(node):
		update_component_groups(node)

func _on_node_removed(node: Node) -> void:
	if ECS.is_component(node):
		var entity: AbstractEntity = node.get_parent()
		if not entity:
			return
		entity.unregister_component(node)
		update_component_groups(entity)
	elif ECS.is_entity(node):
		for component_group in component_groups:
			var entity_list: Array = component_groups[component_group]
			entity_list.erase(node.id)

func _on_tree_exiting() -> void:
	var tree: SceneTree = get_tree()
	tree.disconnect("node_added", _on_node_added)
	tree.disconnect("node_removed", _on_node_removed)
	disconnect("tree_exiting", _on_tree_exiting)
