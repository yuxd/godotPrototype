extends Control

enum CardState { normal, dragging, preview, selected }
enum AbilityTargetType {all, our_all, they_all, our_single, they_single}

export (String) var card_name
export (bool) var is_back
export (float) var tween_speed = 0.2
export (CardState) var card_state = CardState.normal
export (AbilityTargetType) var ability_target = AbilityTargetType.all
export (Vector2) var preview_scale = Vector2(0.5,0.5)
export (Vector2) var preview_position = Vector2(0,10)

onready var card = $t_card
onready var card_back_resource = preload("res://cards/texture/backB.png")
onready var tween : Tween = $Tween
onready var timer = $Timer

var card_resource_path = "res://Cards/texture/"
var card_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	card.rect_pivot_offset = Vector2(card.rect_size.x/2,card.rect_size.y)
	# update_position(Vector2(100,100))
	if is_back == true:
		card.texture = card_back_resource
	else:
		var card_res_file = card_resource_path + card_name + ".png"
		card.texture = load(card_res_file)

func _on_Card_mouse_entered():
	timer.start()
	card_manager.selected_card = self

func _on_Card_mouse_exited():
	timer.stop()
	card_manager.selected_card = null
	if card_state == CardState.preview:
		preview()

func _on_Timer_timeout():
	# preview()
	if card_state == CardState.normal:
		card_manager.on_card_preview(self)

func _on_Card_gui_input(event:InputEvent):
	pass

func preview():
	var item = card.get_canvas_item()
	match card_state:
		CardState.normal:
			# print(self.rect_rotation)
			self.card_state = CardState.preview
			var target_position = rect_position - preview_position
			var target_scale = rect_scale + preview_scale
			# print("preview",target_position,target_scale)
			# tween.interpolate_property(card,"rect_position",
			# 	card.rect_position, target_position,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.interpolate_property(card,"rect_rotation",
				card.rect_rotation,- rect_rotation,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.interpolate_property(card,"rect_scale",
				card.rect_scale,target_scale,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.start()
#			z_index = VisualServer.canvas_item_get_z_index(item)
			VisualServer.canvas_item_set_z_index(item, 1)
		CardState.preview:
			# print(self.rect_rotation)
			tween.interpolate_property(card,"rect_rotation",
				card.rect_rotation, 0,tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.interpolate_property(card,"rect_scale",
				card.rect_scale, Vector2(1,1),tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.start()
			self.card_state = CardState.normal
			VisualServer.canvas_item_set_z_index(item, 0)

func is_all_target() -> bool :
	match ability_target:
		AbilityTargetType.all:
			return true
		AbilityTargetType.our_all:
			return true
		AbilityTargetType.they_all:
			return true
		AbilityTargetType.our_single:
			return false
		AbilityTargetType.they_ingle:
			return false
		_:
			return false
