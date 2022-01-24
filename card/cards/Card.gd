extends Control
class_name Card

enum AbilityTargetType {all, our_all, they_all, our_single, they_single}
enum CardState { normal, dragging, preview, prerelease }

var card_manager
var can_release : bool = false

export(Resource) var card_resource

export (CardState) var card_state = CardState.normal
export (AbilityTargetType) var ability_target = AbilityTargetType.all
export (bool) var is_back

onready var card = $t_card
onready var tween : Tween = $Tween
onready var timer_preview = $timer_preview
onready var timer_release = $timer_release

# Called when the node enters the scene tree for the first time.
func _ready():
	card.rect_pivot_offset = Vector2(card.rect_size.x/2,card.rect_size.y)
	# update_position(Vector2(100,100))
	if is_back == true:
		card.texture = card_resource.card_back_resource
	else:
		var card_res_file = card_resource.card_resource_path + card_resource.card_name + ".png"
		card.texture = load(card_res_file)

func _on_Card_mouse_entered():
	if card_manager != null:
		timer_preview.start()
		card_manager.selected_card = self

func _on_Card_mouse_exited():
	timer_preview.stop()
	if self.is_all_target():
		card_manager.selected_card = null
	else:
		pass
	if card_state == CardState.preview:
		preview()

func preview():
	# print("preview")
	var item = card.get_canvas_item()
	match card_state:
		CardState.normal:
			# print(self.rect_rotation)
			self.card_state = CardState.preview
			var target_position = rect_position - card_resource.preview_position
			var target_scale = rect_scale + card_resource.preview_scale
			# print("preview",target_position,target_scale)
			# tween.interpolate_property(card,"rect_position",
			# 	card.rect_position, target_position,card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.interpolate_property(card,"rect_rotation",
				card.rect_rotation,- rect_rotation,card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.interpolate_property(card,"rect_scale",
				card.rect_scale,target_scale,card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.start()
#			z_index = VisualServer.canvas_item_get_z_index(item)
			VisualServer.canvas_item_set_z_index(item, 1)
		CardState.preview:
			# print(self.rect_rotation)
			tween.interpolate_property(card,"rect_rotation",
				card.rect_rotation, 0,card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.interpolate_property(card,"rect_scale",
				card.rect_scale, Vector2(1,1),card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.start()
			self.card_state = CardState.normal
			VisualServer.canvas_item_set_z_index(item, 0)

func predragging():
	if card_state == CardState.prerelease:
		print("predragging")
		tween.interpolate_property(card,"rect_scale",
			card.rect_scale, Vector2(1,1),card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
		tween.start()
		card_state = CardState.dragging

func prerelease():
	if card_state != CardState.prerelease:
		# print("prerelease")
		tween.interpolate_property(card,"rect_scale",
			card.rect_scale, Vector2(1.5,1.5),card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
		tween.start()
		card_state = CardState.prerelease

func release():
	pass


func _on_timer_preview_timeout():
	# preview()
	# print(card_state)
	timer_preview.stop()
	if card_state == CardState.normal:
		card_manager.on_card_preview(self)
	
func _on_timer_release_timeout():
	pass # Replace with function body.


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
		AbilityTargetType.they_single:
			return false
		_:
			return false
