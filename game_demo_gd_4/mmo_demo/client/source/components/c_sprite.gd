extends Sprite2D
class_name SpriteComponent

const component_name := "C_Sprite"

var synchronizer : MultiplayerSynchronizer

func _ready():
	synchronizer = get_parent().get_node("MultiplayerSynchronizer")
#	assert(synchronizer != null)
