extends RigidBody2D


func get_object_type():
	return "axe"

func action(character):
	character.pickup(self)
