extends Control
class_name Card

enum AbilityTargetType {all, our_all, they_all, our_single, they_single}
enum CardState { normal, dragging, preview, prerelease }

var card_manager
var can_release : bool = false

@export var card_resource : Resource

@export var card_state : CardState = CardState.normal
@export var ability_target : AbilityTargetType = AbilityTargetType.all
@export var is_back : bool

@onready var card : TextureRect = $t_card
#@onready var tween : Tween = get_tree().create_tween()
@onready var timer_preview = $timer_preview
@onready var timer_release = $timer_release

# Called when the node enters the scene tree for the first time.
func _ready():
	card.pivot_offset = Vector2(card.size.x/2,card.size.y)
	# update_position(Vector2(100,100))
	if is_back == true:
		card.texture = card_resource.card_back_resource
	else:
		var card_res_file = card_resource.card_resource_path \
			+ card_resource.card_name + ".png"
		card.texture = load(card_res_file)


func _on_Card_mouse_entered():
	assert(card_manager != null, "card manager is null!")
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
			# print(self.rotation)
			self.card_state = CardState.preview
			var target_position = position - card_resource.preview_position
			var target_scale = scale + card_resource.preview_scale
			# print("preview",target_position,target_scale)
			# tween.interpolate_property(card,"position",
			# 	card.position, target_position,card_resource.tween_speed,Tween.TRANS_BACK,Tween.EASE_IN)
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(card, "rotation", - rotation, card_resource.tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.tween_property(card, "scale", target_scale, card_resource.tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.play()
#			z_index = VisualServer.canvas_item_get_z_index(item)
			RenderingServer.canvas_item_set_z_index(item, 1)
		CardState.preview:
			# print(self.rotation)
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(card,"rotation", 0, card_resource.tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.tween_property(card,"scale", Vector2(1,1), card_resource.tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.play()
			self.card_state = CardState.normal
			RenderingServer.canvas_item_set_z_index(item, 0)

func predragging():
	if card_state == CardState.prerelease:
		print("predragging")
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(1,1), card_resource.tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.play()
		card_state = CardState.dragging

func prerelease():
	if card_state != CardState.prerelease:
		# print("prerelease")
		var tween : Tween = get_tree().create_tween()
		tween.interpolate_property(card, "scale", Vector2(1.5,1.5), card_resource.tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.play()
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
