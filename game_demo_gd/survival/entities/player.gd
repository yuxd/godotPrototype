extends Node2D
class_name Player

export var player_state : Resource

func _ready():
    GameInstance.player = self