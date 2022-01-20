extends Control

export(float) var offset_x_proportion = 0.4
export(float) var rotation_proportion = 5
export(float) var tween_speed = 0.2

onready var t_card = preload("res://cards/card.tscn")

onready var hand_card = $hand_card
onready var deck = $deck
onready var card_preview = $card_preview
onready var tween = $Tween
onready var arrow = $bessel_arrow
onready var max_card_amount : int = 13

var cards = []
var card_amount : int = 0
var offset_x

var dragging = false
var click_pisition
var card_wait_for_add = 0
var selected_card

var can_release_card : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	card_preview.rect_pivot_offset = Vector2(card_preview.rect_size.x/2,card_preview.rect_size.y)
#	card_preview.hide()
	update_card_position()

func _process(delta):
	if dragging and selected_card != null:
			# _on_card_dragging(selected_card)
			if selected_card.is_all_target():
				_on_card_dragging(selected_card)
				# pass
			else:
				# 否则，不拖拽，显示选择目标的箭头曲线
				arrow.reset(click_pisition,get_viewport().get_mouse_position())
				# selected_card.card.hide()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
			click_pisition =  event.position
			if selected_card !=  null and selected_card.is_all_target():
				if selected_card.card_state == selected_card.CardState.normal:
					selected_card.predragging()
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			arrow.hide()
			# 松开鼠标按键，判断是否可释放
			dragging = false
			update_card_position()
			if selected_card:
				if selected_card.is_all_target():
					pass
				else:
					pass
				selected_card = null
				

func update_card_position():
	cards = hand_card.get_children()
	if cards.size() == 0:
		return
	card_amount = cards.size()
	offset_x = cards[0].rect_min_size.x
	for i in range(0, card_amount):
		var card_offset = card_amount * -0.5 + 0.5 + 1* i
		cards[i].rect_pivot_offset = Vector2(cards[i].rect_size.x/2,cards[i].rect_size.y)		
		# 位置偏移
		# cards[i].rect_position.x = card_offset * offset_x * offset_x_proportion
		# 旋转偏移
		# cards[i].rect_rotation = card_offset * rotation_proportion
		var target_position = Vector2(card_offset * offset_x * offset_x_proportion * max_card_amount/card_amount , 0)
		var target_rotation = card_offset * rotation_proportion
		var target_scale = Vector2(1,1)

		tween.interpolate_property(cards[i],"rect_position",cards[i].rect_position,target_position,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
		tween.interpolate_property(cards[i],"rect_rotation",cards[i].rect_rotation,target_rotation,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
		tween.interpolate_property(cards[i],"rect_scale",cards[i].rect_scale,target_scale,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
		tween.start()

		if cards[i].card_manager == null:
			cards[i].card_manager = self
		# cards[i].card_state = cards[i].CardState.normal
		cards[i].card.show()
		

func _add_card(pos:Vector2):
	var card = t_card.instance()
	hand_card.add_child(card)
	cards.append(card)
	card.rect_scale = Vector2(0,0)
	card.rect_position = pos - hand_card.rect_position
	update_card_position()
	card_wait_for_add -= 1

func add_cards(n:int,pos:Vector2):
	card_wait_for_add = n
	_add_card(pos)

func remove_card(card):
	if cards.size() == 0:
		return
	cards.erase(card)
	hand_card.remove_child(card)
	update_card_position()

func get_card_position(card_index : int) -> Vector2:
	card_amount = cards.size()
	var card_offset = card_amount * -0.5 + 0.5 + 1* card_index
	cards[card_index].rect_pivot_offset.x = cards[card_index].rect_min_size.x/2
	cards[card_index].rect_pivot_offset.y = cards[card_index].rect_min_size.y
	
	# 位置偏移
	cards[card_index].rect_position.x = card_offset * offset_x * offset_x_proportion
	# 旋转偏移
	cards[card_index].rect_rotation = card_offset * rotation_proportion
	
	return Vector2(0,0)

#########################################

func on_card_preview(card):
	card.preview()
	# if tween.is_active():
	# 	return
	# var target_position = card.rect_position + card.preview_position
	# var target_scale = card.rect_scale + card.preview_scale
	# tween.interpolate_property(card,"rect_position",
	# 	card.rect_position, target_position,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	# tween.interpolate_property(card,"rect_rotation",
	# 	card.rect_rotation,0.0,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	# tween.interpolate_property(card,"rect_scale",
	# 	card.rect_scale,target_scale,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	# tween.start()
	# card.card_state = card.CardState.preview

func _on_card_dragging(card):
	if card.card_state == card.CardState.preview:
		# 如果当前是预览状态，需要还原一下
		card.preview()
	card.rect_rotation = 0
	card.rect_scale = Vector2(1.2,1.2)
	card.rect_position = get_viewport().get_mouse_position() - hand_card.rect_position

func _on_btn_add_card_pressed():
	add_cards(2,deck.position)

func _on_btn_remove_card_pressed():
	remove_card(cards[1])

func _on_btn_preview_pressed():
	on_card_preview(cards[2])

func _on_Tween_tween_completed(object, key):
	if card_wait_for_add != 0:
		_add_card(deck.position)
