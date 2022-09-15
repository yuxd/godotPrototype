extends Resource
class_name CardConfig

@export var card_name : String
@export var tween_speed : float = 0.2
@export var preview_scale := Vector2(1,1)
@export var preview_position := Vector2(0,10)
#@onready var card_back_resource : Texture = preload("res://cards/texture/backB.png")
var card_resource_path :String= "res://Cards/texture/"
