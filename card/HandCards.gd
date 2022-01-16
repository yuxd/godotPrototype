extends Container

export(float) var offset_x_proportion = 0.2
export(float) var rotation_proportion = 10

var cards
var card_amount : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_card_position()

func update_card_position():
	cards = get_children()
	card_amount = cards.size()
	var offset_x = cards[0].rect_min_size.x
	print(offset_x)
	for i in range(0, card_amount):
		var card_offset = card_amount * -0.5 + 0.5 + 1* i
#		print(card_amount * -0.5 + 0.5 + 1* i)
		cards[i].rect_pivot_offset.x = cards[i].rect_min_size.x/2
		cards[i].rect_pivot_offset.y = cards[i].rect_min_size.y
		
		# 位置偏移
		cards[i].rect_position.x = card_offset * offset_x * offset_x_proportion
		# 旋转偏移
		print(card_amount * -0.5 + 0.5 + 1* i)
		cards[i].rect_rotation = card_offset * rotation_proportion

func add_card(from:Vector2):
	pass
