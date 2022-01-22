extends Resource
class_name CardResource

export (String) var card_name
export (float) var tween_speed = 0.2
export (Vector2) var preview_scale = Vector2(1,1)
export (Vector2) var preview_position = Vector2(0,10)
onready var card_back_resource = preload("res://cards/texture/backB.png")
var card_resource_path = "res://Cards/texture/"
