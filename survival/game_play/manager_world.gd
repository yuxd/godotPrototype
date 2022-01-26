extends CanvasLayer
class_name WorldManager

# Called when the node enters the scene tree for the first time.
func _ready():
	GameInstance.world_manager = self
	GameInstance.entity_manager.create_entity()
	GameInstance.entity_manager.create_build()
