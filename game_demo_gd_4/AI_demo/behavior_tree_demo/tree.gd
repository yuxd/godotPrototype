extends StaticBody2D

@export var can_cut : bool = false


func get_object_type():
	if can_cut:
		return "tree"
	else:
		return "tree_not_ready"


func set_grown():
	$AnimationPlayer.play("Grown")


func cut(character):
	if !can_cut:
		print("This tree cannot be cut")
	elif (character.position - position).length() > 1:
		print("This tree is too far")
	elif character.held != null and character.held.get_object_type() == "axe":
		$AnimationPlayer.play("Cut")
		return true
	else:
		print("you need an axe to cut a tree")
	return false
