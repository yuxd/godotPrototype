extends Control

export (String) var card_name
export (bool) var is_back
export (float) var tween_speed = 0.2

onready var card = $t_card
onready var card_back_resource = preload("res://Cards/backB.png")
onready var tween : Tween = $Tween

var card_resource_path = "res://Cards/"

# Called when the node enters the scene tree for the first time.
func _ready():

	# update_position(Vector2(100,100))

	if is_back == true:
		card.texture = card_back_resource
	else:
		var card_res_file = card_resource_path + card_name + ".png"
		card.texture = load(card_res_file)

func update_card_position(target_position:Vector2):
	tween.interpolate_property(self,"rect_position",self.rect_position,target_position,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	tween.start()

func update_card_rotation(target_rotation : float):
	tween.interpolate_property(self,"rect_rotation",self.rect_rotation,target_rotation,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	tween.start()
