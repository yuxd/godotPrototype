extends Control

enum CardState { normal, dragging, preview, selected }
enum AbilityTargetType {all, our_all, they_all, our_single, they_single}

export (String) var card_name
export (bool) var is_back
export (float) var tween_speed = 0.2
export (CardState) var card_state = CardState.normal
export (AbilityTargetType) var ability_target = AbilityTargetType.all

onready var card = $t_card
onready var card_back_resource = preload("res://cards/texture/backB.png")
onready var tween : Tween = $Tween
onready var timer = $Timer

var card_resource_path = "res://Cards/texture/"
var card_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	# update_position(Vector2(100,100))
	if is_back == true:
		card.texture = card_back_resource
	else:
		var card_res_file = card_resource_path + card_name + ".png"
		card.texture = load(card_res_file)

func _on_Card_mouse_entered():
	# timer.start()
	card_manager.selected_card = self


func _on_Card_mouse_exited():
	# timer.stop()
	card_manager.selected_card = null


func _on_Timer_timeout():
	if card_state == CardState.normal:
		card_manager.on_card_preview(self)


func _on_Card_gui_input(event:InputEvent):
	pass
