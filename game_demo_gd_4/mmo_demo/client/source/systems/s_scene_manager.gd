extends System
class_name SceneManagerSystem

var event_remove_from_scene :EventResource = load("res://source/events/event_remove_from_scene.tres")

func _init():
	system_name = "S_SceneManager"
	requirements = ["C_Sprite"]

func _system_ready():
	event_remove_from_scene.subscribe(remove_from_scene)


func return_to_scene(e : Entity):
	if not e.meets_requirements(requirements):
		return


func remove_from_scene(e : Entity):
	var sprite : SpriteComponent = e.get_component("C_Sprite")
	if sprite : sprite.hide()
