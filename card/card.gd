extends Control

export (String) var card_name
export (bool) var is_back

onready var card = $t_card
onready var card_back_resource = preload("res://Cards/backB.png")
var card_resource_path = "res://Cards/"

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_back == true:
		card.texture = card_back_resource
	else:
		var card_res_file = card_resource_path + card_name + ".png"
		card.texture = load(card_res_file)
