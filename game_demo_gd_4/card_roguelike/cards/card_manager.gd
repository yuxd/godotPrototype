extends Control

@export var offset_x_proportion : float = 0.4
@export var rotation_proportion: float = 5
@export var tween_speed : float = 0.2
@export var hand_card_position : Vector2 = Vector2(480,510)

@onready var t_card : PackedScene = preload("res://cards/card.tscn")

@onready var hand_card : Control = $hand_card
@onready var deck : Control = $deck
@onready var cemetery : Control = $cemetery
# onready var card_preview = $card_preview
#@onready var tween : Tween = get_tree().create_tween()
@onready var arrow :Node2D = $bessel_arrow
#@onready var tween_remove_card : Tween = get_tree().create_tween()

@onready var max_card_amount : int = 12

var card_remove_index := 0

var cards : Array : 
	get : return hand_card.get_children()
var card_amount : int = 0
var offset_x

var dragging = false
var click_pisition
var card_wait_for_add = 0
var selected_card

var can_release_card : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	card_preview.pivot_offset = Vector2(card_preview.size.x/2,card_preview.size.y)
#	card_preview.hide()
	for c in cards:
		c.queue_free()
	for i in range(0, 5):
		var card : Card = t_card.instantiate()
		hand_card.add_child(card)
		printerr(card.rotation)
	update_card_position()

func _process(delta):
	if dragging and selected_card != null:
			# _on_card_dragging(selected_card)
			if selected_card.is_all_target():
				_on_card_dragging(selected_card)
				if get_viewport_rect().size.y * 0.8 > get_viewport().get_mouse_position().y:
					selected_card.prerelease()
				else:
					selected_card.predragging()
			else:
				# 否则，不拖拽，显示选择目标的箭头曲线
				arrow.reset(click_pisition,get_viewport().get_mouse_position())
				# selected_card.card.hide()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
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
			if selected_card:
				if selected_card.is_all_target():
					if selected_card.can_release:
						selected_card.release()
					else:
						selected_card.predragging()
				else:
					pass 
				selected_card = null
				
			update_card_position()


func update_card_position():
	if cards.size() == 0:
		return
	card_amount = cards.size()
	offset_x = cards[0].size.x
	for i in cards.size():
		var card : Card = cards[i]
		var card_offset = card_amount * -0.5 + 0.5 + 1 * i
#		card.pivot_offset = Vector2(cards[i].size.x/2,cards[i].size.y)
		# 位置偏移
#		card.position.x = card_offset * offset_x * offset_x_proportion
#		printerr(" card position x: ", card.position.x, " card_offset: ", card_offset, \
#			" offset_x_proportion: ", offset_x_proportion, " offset_x: ", offset_x)
		# 旋转偏移
		# cards[i].rotation = card_offset * rotation_proportion
		var target_position = Vector2(card_offset * offset_x * offset_x_proportion * (1 if card_amount <= max_card_amount else max_card_amount/card_amount) , 0) 
		var target_rotation = card_offset * rotation_proportion
		var target_scale = Vector2(1,1)
#		assert(tween, '没找到 tween')
		var tween : Tween = get_tree().create_tween()
		tween.finished.connect(_on_tween_update_position_completed)
		tween.tween_property(card, "position", target_position, tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
#TODO		tween.tween_property(cards[i],"rotation", target_rotation,tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_property(card, "scale", target_scale, tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.play()
#		card.rotation = i * rotation_proportion
#		printerr("card rotation: ", card.rotation, "i: ", i, "rotation_proportion: ", rotation_proportion)
		if card.card_manager != self:
			card.card_manager = self
		# cards[i].card_state = cards[i].CardState.normal
		card.card.show()
		

func _add_card(pos:Vector2):
	var card = t_card.instantiate()
	hand_card.add_child(card)
	card.scale = Vector2(0,0)
	card.position = pos - hand_card.position
	update_card_position()
	card_wait_for_add -= 1

func add_cards(n:int, pos:Vector2):
	card_wait_for_add = n
	_add_card(pos)

func remove_card(card):
	if cards.size() == 0:
		return
	var target_position = cemetery.position - hand_card.position
	# var target_rotation = card_offset * rotation_proportion
	var target_scale = Vector2(0,0)
	var tween_remove_card : Tween = get_tree().create_tween()
	tween_remove_card.finished.connect(_on_tween_remove_card_tween_completed)
	tween_remove_card.tween_property(card, "position", target_position, tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# tween.interpolate_property(card,"rotation",card.rotation,target_rotation,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	tween_remove_card.tween_property(card, "scale", target_scale, tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween_remove_card.play()


func get_card_position(card_index : int) -> Vector2:
	card_amount = cards.size()
	var card_offset = card_amount * -0.5 + 0.5 + 1* card_index
	cards[card_index].pivot_offset.x = cards[card_index].min_size.x/2
	cards[card_index].pivot_offset.y = cards[card_index].min_size.y
	
	# 位置偏移
	cards[card_index].position.x = card_offset * offset_x * offset_x_proportion
	# 旋转偏移
	cards[card_index].rotation = card_offset * rotation_proportion
	
	return Vector2(0,0)

#########################################

func on_card_preview(card):
	card.preview()
	# if tween.is_active():
	# 	return
	# var target_position = card.position + card.preview_position
	# var target_scale = card.scale + card.preview_scale
	# tween.interpolate_property(card,"position",
	# 	card.position, target_position,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	# tween.interpolate_property(card,"rotation",
	# 	card.rotation,0.0,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	# tween.interpolate_property(card,"scale",
	# 	card.scale,target_scale,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
	# tween.start()
	# card.card_state = card.CardState.preview

func _on_card_dragging(card):
	if card.card_state == card.CardState.preview:
		# 如果当前是预览状态，需要还原一下
		card.preview()
	card.rotation = 0
	card.scale = Vector2(1.2,1.2)
	card.position = get_viewport().get_mouse_position() - hand_card.position

func _on_btn_add_card_pressed():
	add_cards(2, deck.position)

func _on_btn_remove_card_pressed():
	card_remove_index = 1
	remove_card(cards[card_remove_index])

func _on_tween_update_position_completed():
	if card_wait_for_add != 0:
		_add_card(deck.position)


func _on_tween_remove_card_tween_completed():
	var card : Card = cards[card_remove_index]
	hand_card.remove_child(card)	
	card.queue_free()
	update_card_position()
