extends Control

enum CardState { zoomIn, zoomOut, returning, dragging, move, settle }

export (String) var card_name
export (bool) var is_back
export (float) var tween_speed = 0.2
export (CardState) var card_state = CardState.dragging

onready var card = $t_card
onready var card_back_resource = preload("res://cards/texture/backB.png")
onready var tween : Tween = $Tween

var card_resource_path = "res://Cards/texture/"


# Called when the node enters the scene tree for the first time.
func _ready():

	# update_position(Vector2(100,100))

	if is_back == true:
		card.texture = card_back_resource
	else:
		var card_res_file = card_resource_path + card_name + ".png"
		card.texture = load(card_res_file)

func _on_Card_mouse_entered():
	print(self.name)


func _on_Card_mouse_exited():
	pass
