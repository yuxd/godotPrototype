extends Node
class_name InventoryComponent

var component_name = "C_Inventory"
var inst : Entity = null

const MAX_SLOTS = 12

var item_slots : Array = []
var max_slots = MAX_SLOTS
var recipes :Dictionary = {}
var recipe_count : int = 0

var equip_slots : Dictionary = {}
var drop_on_death : bool = false

# var active_item : InventoryItemComponent setget set_active_item, get_active_item
var accepts_stacks : bool = true
var ignore_scan_go_in_container : bool = true
var open_containers : Dictionary = {}
var selected_slot_index : int = 0 
#	: set = _set_selected_slot


func _init():
	self.resource_name = "inventory"


func _ready():
#	yield(owner,"_enter_tree")
	for i in range(max_slots):
		if i < item_slots.size():
			item_slots[i] = null
		else:
			item_slots.append(null)


#func _set_selected_slot(value):
#	self.emit_signal("seleced_slot_change", self.selected_slot_index, value)
#	selected_slot_index = value
