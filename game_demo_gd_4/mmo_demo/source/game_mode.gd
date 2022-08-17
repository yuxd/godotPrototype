extends Node2D
class_name GameMode

var buildings : Dictionary = {}
var persons : Dictionary = {}

@onready var order_group : Node = $order_group

func _ready():
	GameInstance.game_main = self
	GameInstance.create_player_character()
