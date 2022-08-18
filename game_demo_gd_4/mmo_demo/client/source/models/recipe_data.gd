extends Resource
class_name RecipeData

export(String) var name : String = "name"
# export(PackedScene) var placer : PackedScene = null 
export(Array, String) var ingredients = []
export(Array, int) var ingredient_amounts = []
export(PackedScene) var product : PackedScene = null
# export var tab           = tab
export(Texture) var imag : Texture = null
# export var sortkey       = num
export(int) var level : int = 0
# var level.ANCIENT = var level.ANCIENT or 0
# var level.MAGIC   = var level.MAGIC or 0
# var level.SCIENCE = var level.SCIENCE or 0
# var level.LOST    = var level.LOST or 0
# var min_spacing   = min_spacing or 3.2
export(bool) var no_unlock : bool = false
export(int) var num_to_give : int = 1
# Recipes[name]      = self

func get_level():
	return level
