extends Control
class_name ItemSlot

var _b_big := false
var slot_index : int = 0
var is_invalid := false : set = _change_is_invalid
var is_lock := false

@export var slot_key : String= ""
@export var can_drop : bool = true
@export var can_drag : bool = true
@export var can_show_tip : bool = true

@onready var lab_key : Label = $lab_key
@onready var selected_node : Control = $MarginContainer/selected
@onready var item_tile : ItemTile = $w_item_tile
@onready var item_use_tip = $item_use_tip
@onready var img_invalid = $img_invalid

signal slot_mouse_entered(item_slot)
signal slot_mouse_exited(item_slot)
signal item_droped(item_slot, data)
signal mouse_button_downed(item_slot, button)

# var inventory_item : InventoryItemComponent = null
func _ready():
	if not item_tile:
		item_tile = self.get_node("item_tile")
	lab_key.text = slot_key
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func highlight():
	selected_node.show()
	
func de_highlight():
	selected_node.hide()
		
func set_item_tile(new_item : InventoryItemComponent):
	if not item_tile:
		printerr("cannot found item tile!")
		return
	item_tile.show_tile(new_item)

func _on_mouse_entered():
	if item_tile.visible and self.can_show_tip:
		item_use_tip.show()
	# printerr("_on_mouse_entered")
	emit_signal("slot_mouse_entered",self)
		
func _on_mouse_exited():
	if item_use_tip : item_use_tip.hide()
	# printerr("_on_mouse_exited")
	emit_signal("slot_mouse_exited",self)
		
func _on_gui_input(event):
	# print_debug("slot pressed - ",event)
	# var player_inventory : InventoryComponent = QInstance.get_player_character().get_component("inventory")
	# if not player_inventory:
	# 	printerr("cannot found inventory component")
	# 	return
	if event is InputEventMouseButton and not self.is_invalid:
		if event.pressed:
			emit_signal("mouse_button_downed", self, event.button_index)
			# player_inventory.selected_slot_index = self.slot_index
			# print_debug("slot pressed")

func get_drag_data(_position):
	if not item_tile.visible or self.is_invalid or not can_drag:
		return null
	item_tile.b_dragging = true
	set_drag_preview(_make_preview())

	item_tile.hide()
	var data = {}
	data["slot_index"] = self.slot_index
	data["item_tile"] = item_tile
	return data

func can_drop_data(_position, data):
	if data.has("item_tile") and data["item_tile"] is ItemTile:
		return can_drop
	return false

func drop_data(_position, data):
	# 当我们拖放到slot时候调用此方法，判断当前槽内是否有对象
	emit_signal("item_droped", self, data)

func _make_preview() -> Control:
	var crl : Control = Control.new()
	var texture_rect = TextureRect.new()
	texture_rect.expand    = true
	texture_rect.texture   = item_tile.img_item.texture
	texture_rect.rect_size = item_tile.img_item.rect_size
	crl.add_child(texture_rect)
	texture_rect.rect_position = -0.5 * texture_rect.rect_size
	return crl

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if item_tile.b_dragging and not event.pressed:
			if item_tile.inventory_item:
				item_tile.show()
			else:
				item_tile.hide()

func _change_is_invalid(value):
	if value:
		img_invalid.show()
		can_show_tip = false
	else:
		img_invalid.hide()
		can_show_tip = true
	is_invalid = value
	
func has_item() -> bool:
	return self.item_tile.inventory_item != null
		
func get_item() -> InventoryItemComponent:
	return item_tile.inventory_item
