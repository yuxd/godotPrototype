extends CanvasLayer

onready var deck = $deck
onready var hand_cards = $HandCards

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_btn_remove_card_pressed():
	hand_cards.remove_card(hand_cards.cards[1])


func _on_btn_add_card_pressed():
	for i in range(1,3):
		hand_cards.add_card(deck.position)

