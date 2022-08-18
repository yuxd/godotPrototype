extends Node2D
class_name SceneBase

var entity_group = null : get = _entity_group_get
#onready var target = get_parent().find_node('Player')
@export var _start_position : Dictionary = {}

signal entity_entered(entity)
signal entity_exited(entity)

var entities := []

func _ready():
	# QInstance.current_scene = self
	pass

func _entity_group_get():
	if not entity_group:
#		entity_group = BetterYSort.new()
		self.add_child(entity_group)
	return entity_group

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func _update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func _physics_update(_delta: float) -> void:
	pass

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func _enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func _exit() -> void:
	pass

func remove_entity(entity) -> void:
	self.entity_group.remove_child(entity)
	entity.emit_signal("remove_from_scene",self)
	self.emit_signal("entity_exited", entity)
	self.on_remove_entity(entity)
	entities.erase(entity)
	print_debug("===== scene: ", self ,"remove_entity: ", entity)

func add_entity(entity) -> void:
	self.entity_group.add_child(entity)
	entity.emit_signal("add_to_scene",self)
	self.emit_signal("entity_entered", entity)
	self.on_add_entity(entity)
	entities.append(entity)
	print_debug("===== scene: ", self ,"add_entity: ", entity)

func on_remove_entity(entity):
	pass

func on_add_entity(entity):
	pass
