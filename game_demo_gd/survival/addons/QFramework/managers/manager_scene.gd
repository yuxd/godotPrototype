# 提供场景管理的功能，可以同时加载多个场景，也可以随时卸载任何一个场景，从而很容易地实现场景的分部加载
extends CanvasLayer
class_name WorldManager

# Called when the node enters the scene tree for the first time.
func _ready():
	GameInstance.world_manager = self
	GameInstance.entity_manager.create_entity()
	GameInstance.entity_manager.create_build()
