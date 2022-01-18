extends Container

export(float) var offset_x_proportion = 0.2
export(float) var rotation_proportion = 10

onready var t_card = preload("res://cards/card.tscn")

var cards = []
var card_amount : int = 0
var offset_x

# Called when the node enters the scene tree for the first time.
func _ready():
	update_card_position()

func update_card_position():
	cards = get_children()
	card_amount = cards.size()
	offset_x = cards[0].rect_min_size.x
	for i in range(0, card_amount):
		var card_offset = card_amount * -0.5 + 0.5 + 1* i
		cards[i].rect_pivot_offset.x = cards[i].rect_min_size.x/2
		cards[i].rect_pivot_offset.y = cards[i].rect_min_size.y
		
		# 位置偏移
		# cards[i].rect_position.x = card_offset * offset_x * offset_x_proportion
		# 旋转偏移
		# cards[i].rect_rotation = card_offset * rotation_proportion

		var target_position = Vector2(card_offset * offset_x * offset_x_proportion , 0)
		var target_rotation = card_offset * rotation_proportion
		cards[i].update_card_position(target_position)
		cards[i].update_card_rotation(target_rotation)
		cards[i].update_card_scale(Vector2(1,1))
		# cards[i].tween.start()

func add_card(pos:Vector2):
	var card = t_card.instance()
	self.add_child(card)
	cards.append(card)
	card.rect_scale = Vector2(0,0)
	# print(self.rect_position)
	# print(pos)
	# print(pos - self.rect_position)
	card.rect_position = pos - self.rect_position	
	update_card_position()

func remove_card(card):
	cards.erase(card)
	self.remove_child(card)
	update_card_position()

func get_card_position(card_index : int) -> Vector2:
	card_amount = cards.size()
	var card_offset = card_amount * -0.5 + 0.5 + 1* card_index
#		print(card_amount * -0.5 + 0.5 + 1* i)
	cards[card_index].rect_pivot_offset.x = cards[card_index].rect_min_size.x/2
	cards[card_index].rect_pivot_offset.y = cards[card_index].rect_min_size.y
	
	# 位置偏移
	cards[card_index].rect_position.x = card_offset * offset_x * offset_x_proportion
	# 旋转偏移
#		print(card_amount * -0.5 + 0.5 + 1* i)
	cards[card_index].rect_rotation = card_offset * rotation_proportion
	
	return Vector2(0,0)
