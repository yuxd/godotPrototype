extends Node
class_name EntityManager

# Called when the node enters the scene tree for the first time.
func _ready():
	GameInstance.entity_manager = self

func create_entity():
	var entity = EntityBase.new()
	entity.add_to_group("cha")
	self.add_child(entity)

func create_build():
	var build = BuildBase.new()
	build.add_to_group("build")
	self.add_child(build)
