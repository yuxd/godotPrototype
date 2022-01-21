extends Resource
class_name CardResource

var name : String
export (String) var card_name
export (bool) var is_back
export (float) var tween_speed = 0.2
export (CardState) var card_state = CardState.normal
export (AbilityTargetType) var ability_target = AbilityTargetType.all
export (Vector2) var preview_scale = Vector2(1,1)
export (Vector2) var preview_position = Vector2(0,10)

onready var card = $t_card
onready var card_back_resource = preload("res://cards/texture/backB.png")
onready var tween : Tween = $Tween
onready var timer_preview = $timer_preview
onready var timer_release = $timer_release

var card_resource_path = "res://Cards/texture/"