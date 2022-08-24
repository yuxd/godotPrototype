extends Control
class_name InventoryBar

#@onready var btn_remove_selected : TextureButton = $HBoxContainer/btn_remove_selected
@onready var hbox_item = $HBoxContainer

var item_slots = {}
var dragging_item : ItemTile = null # setget _set_dragging_item
var player_inventory : InventoryComponent = null
var selected_slot : ItemSlot = null : set = _set_selected_slot

var inspect_event = null
var event_item_changed : EventResource= load("res://source/events/event_item_changed.tres")

func _ready():
	event_item_changed.subscribe(_on_item_changed)
#	QInstance.connect("change_player_character",self,"_on_change_player_character")

	for i in hbox_item.get_children().size():
		var item_slot : ItemSlot = hbox_item.get_child(i)
		item_slots[i] = item_slot
		item_slot.slot_index = i
		item_slot.connect("slot_mouse_entered",self._on_mouse_enter_slot)
		item_slot.connect("slot_mouse_exited",self._on_mouse_exit_slot)
		item_slot.connect("mouse_button_downed",self._on_mouse_button_down)
		item_slot.connect("item_droped",self._on_drop_item)
#		item_slot.item_use_tip.set_tip("使用")
	self.selected_slot = self.item_slots[0]
#	if QInstance.player_character:
#		_inventory_init(QInstance.player_character)
	# btn_remove_selected.connect("pressed", self, "_on_btn_remove_selected_pressed")


#func _inventory_init(player : Entity):
#	if player and player.has_component("inventory"):
#		player_inventory = player.get_component("inventory")
#		for i in player_inventory.item_slots.size():
#			if i != null:
#				var item = player_inventory.item_slots[i]
#				item_slots[i].set_item_tile(item)
#		self.selected_slot = self.item_slots[self.player_inventory.selected_slot_index]
#		self.player_inventory.connect("item_chanage",self,"_on_item_change")
#		# self.player_inventory.connect("change_active_slot",self,"_on_change_active_slot")
#		self.player_inventory.connect("item_swap",self,"_on_item_swap")
#		self.player_inventory.connect("seleced_slot_change",self,"_seleced_slot_change")
#		self.selected_slot = self.item_slots[self.player_inventory.selected_slot_index]

func _on_btn_remove_selected_pressed():
	if not player_inventory:
		return
	player_inventory.remove_selected_item()

#func _on_change_player_character(player : EntityBase):
#	if not player.has_component("inventory"):
#		print_debug("player dont has inventory component!",player)
#		return
#
#	self.player_inventory = player.get_component("inventory")
#	if not self.player_inventory :
#		print_debug(" player_inventory is null!")
#		return
#	_inventory_init(player)

func _set_selected_slot(value):
	if not value:
		self.selected_slot.de_highlight()
		return		
	selected_slot = value
	self.selected_slot.highlight()

func _seleced_slot_change(_old_slot_index, new_slot_index):
	self.selected_slot.de_highlight()
	self.selected_slot = self.item_slots[new_slot_index]

func _on_item_swap(old_slot, new_slot):
	self.item_slots[old_slot].set_item_tile(self.player_inventory.get_item_by_index(old_slot))
	self.item_slots[new_slot].set_item_tile(self.player_inventory.get_item_by_index(new_slot))

func _on_mouse_enter_slot(item_slot):
	if not item_slot.item_tile.visible:
		return

	if self.inspect_event and self.inspect_event is EventResource:
		if not item_slot.item_tile.inventory_item:
			# print_debug("inventory item is null")
			return
		self.inspect_event.emit_custom_signal(item_slot.item_tile.inventory_item)

func _on_mouse_exit_slot(item_slot):
	if self.inspect_event and self.inspect_event is EventResource:
		if not item_slot.item_tile.inventory_item:
			# print_debug("inventory item is null")
			return
		self.inspect_event.emit_custom_signal(null)

func _on_mouse_button_down(item_slot : ItemSlot, button):
	if not item_slot.item_tile.visible:
		return
	player_inventory.selected_slot_index = item_slot.slot_index

func _on_drop_item(item_slot, data):
	var drag_slot_index = data["slot_index"]
	# var drag_item_tile = data["item_tile"]
	player_inventory.swap_item(drag_slot_index, item_slot.slot_index)
	player_inventory.selected_slot_index = item_slot.slot_index
	item_slot.item_tile.b_dragging = false


func _on_item_changed(inventory_entity : Entity, item_index : int, \
		old_item : InventoryItemComponent, new_item : InventoryItemComponent):
	'''
	道具改变时更新道具显示
	'''
	if inventory_entity != GameInstance.player_character : return
	print_debug("inventory_bar : _on_item_changed : ", item_index, new_item)
	var item_slot : ItemSlot = item_slots[item_index]
	item_slot.set_item_tile(new_item)
