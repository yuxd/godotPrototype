extends Node2D
class_name GameMode

var buildings : Dictionary = {}
var persons : Dictionary = {}

@onready var order_group : Node = $order_group
var event_add_item : EventResource = load("res://source/events/event_add_item.tres")

func start_game():
	GameInstance.game_main = self
	var player = GameInstance.create_player_character()
	var tool = GameInstance.create_entity("tool")
	GameInstance.game_main.add_child(tool)
#	event_add_item.subscribe(_add_item)	
	event_add_item.emit([player, tool])

func _add_item(player, tool):
	printerr("game mode _add_item")
