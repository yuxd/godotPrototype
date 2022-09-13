extends System
class_name SceneManagerSystem

var event_remove_from_scene :EventResource = load("res://source/events/event_remove_from_scene.tres")

func _init():
	system_name = "S_SceneManager"
	requirements = ["C_Prescene"]

func _system_ready():
	event_remove_from_scene.subscribe(remove_from_scene)
	

func _system_process(_entities: Array, _delta: float) -> void:
	for e in _entities:
		init_prescene(e)
		pass
		

func return_to_scene(e : Entity):
	if not e.meets_requirements(requirements):
		return


func remove_from_scene(e : Entity):
	if not e.meets_requirements(requirements):
		return	
#	var sprite : SpriteComponent = e.get_component("C_Sprite")
#	if sprite : sprite.hide()
	e.hide()


func init_prescene(e : Entity) -> void:
	var c_prescene : PresceneComponent = e.get_component("C_Prescene")
	if c_prescene.owner_scene == null:
		c_prescene.owner_scene = e.get_parent()
