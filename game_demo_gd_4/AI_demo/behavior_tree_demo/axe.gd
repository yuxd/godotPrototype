extends RigidBody2D


func _enter_tree():
	owner.game_objects.append(self)


func get_object_type() -> String:
	return "axe"


func action(character):
	character.pickup(self)
