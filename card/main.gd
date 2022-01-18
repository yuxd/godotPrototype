extends CanvasLayer

onready var deck = $deck
onready var hand_cards = $HandCards
onready var arrow = $arrow

var dragging = false
var click_pisition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_btn_remove_card_pressed():
	hand_cards.remove_card(hand_cards.cards[1])


func _on_btn_add_card_pressed():
	for i in range(1,3):
		hand_cards.add_card(deck.position)

func _process(delta):
	if dragging:
		arrow.reset(click_pisition,get_viewport().get_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
			click_pisition =  event.position
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
