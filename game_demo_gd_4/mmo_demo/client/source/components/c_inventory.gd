extends Node
class_name InventoryComponent

var component_name = "c_inventory"
var inst : Entity = null

const MAX_SLOTS = 12

var item_slots : = []
var max_slots = MAX_SLOTS
var recipes :Dictionary = {}
var recipe_count : int = 0

var equip_slots : Dictionary = {}
var drop_on_death : bool = false

# var active_item : InventoryItemComponent setget set_active_item, get_active_item
var accepts_stacks : bool = true
var ignore_scan_go_in_container : bool = true
var open_containers : Dictionary = {}
var selected_slot_index : int = 0 setget _set_selected_slot

signal item_chanage(slot_index, item, new_item)
signal item_swap(old_slot_index, new_slot_index)
signal seleced_slot_change(old_slot_index, new_slot_index)

func _init():
	self.resource_name = "inventory"

func _component_ready():
#	yield(owner,"_enter_tree")
	for i in range(max_slots):
		if i < item_slots.size():
			item_slots[i] = null
		else:
			item_slots.append(null)

func _set_selected_slot(value):
	self.emit_signal("seleced_slot_change", self.selected_slot_index, value)
	selected_slot_index = value

func add_item_by_slot(item_entity: EntityBase, slot_index : int):
	_give_item(item_entity,slot_index)

func add_item(item_entity) -> bool:
	if not item_entity.has_component("inventory_item"):
		printerr("connot add item ,it hasnot component inventory_item : ", item_entity.name)
		return false

	var item : InventoryItemComponent = item_entity.get_component("inventory_item")
	if item.can_stack:
		var slot = get_stacked_slot_by_item(item)
		if slot == -1 :
			return _give_item_empty_slot(item_entity)
		else:
			var current_item : InventoryItemComponent = item_slots[slot]
			if not current_item.is_type_identical(item) :
				return _give_item_empty_slot(item_entity)
			else:
				# 开始合并道具
				var current_count = current_item.item_count
				var max_count = current_item.max_stacked
				if current_count + item.item_count <= max_count:
					# 直接合并
					item.item_count = current_count + item.item_count
					return _give_item( item_entity, slot)
				else:
					if self.found_empty_slot() != -1:
						# 合并之后还多道具
						current_item.item_count = max_count
						self.emit_signal("item_chanage",slot,current_item,current_item)
						item.item_count = item.item_count - max_count + current_count
						return add_item(item_entity)
					else:
						return false
	else:
		return _give_item_empty_slot(item_entity)

func found_empty_slot() -> int:
	for i in range(item_slots.size()):
		if item_slots[i] == null:
			return i
	# 如果找不到，返回 -1
	return -1

func get_stacked_slot_by_item(item: InventoryItemComponent)-> int:
	for i in item_slots.size():
		var slot_item : InventoryItemComponent = item_slots[i]
		if not slot_item:
			break
		if slot_item and slot_item.is_type_identical(item) and slot_item.item_count != slot_item.max_stacked:
			return i
	return -1

func get_slot_by_item(item:InventoryItemComponent) -> int:
	# 相同类型道具，可以进行 叠加 操作
	for i in item_slots.size():
		var slot_item : InventoryItemComponent = item_slots[i]
		if not slot_item:
			break
		if slot_item and slot_item.is_type_identical(item):
			return i
	return -1

func found_slot_can_give(item:InventoryItemComponent) -> int:
	if item.item_resource.can_stack and get_slot_by_item(item) != -1:
		return get_slot_by_item(item) 
	else:
		return found_empty_slot()

func get_item_by_index(index:int) -> InventoryItemComponent:
	if index > max_slots :
		print_debug("can not get item , max slot :", index)
		return null
	return item_slots[index]

func _give_item_empty_slot(item:EntityBase) -> bool:
	# 将道具添加到空闲的位置
	var slot = self.found_empty_slot()
	if slot == -1 :
		print_debug("can not found empty slot")
		return false
	_give_item( item, slot)
	return true

func _give_item( entity : EntityBase, slot_index, _screen_src_pos = null, _skipsound = null ):	
	
	if slot_index > self.max_slots :
		print_debug("cannot give item, max slots :" + slot_index)
		return
			
	# 如果一个entity 有 inventory item component,就可以理解成一个item
	if not entity is EntityBase:
		printerr("inst is null!")
		return
	
	if not entity.has_component("inventory_item"):
		print_debug("inst to give inventory dont have inventory item component")
		return

	var inventory_item : InventoryItemComponent = entity.get_component("inventory_item")	
	if not inventory_item:
		printerr("can not found inventory item component!")
		return

	var old_item : InventoryItemComponent = null
	if item_slots[slot_index] != null:
		# TODO 如果不为空，首先drop 这个位置的道具
		old_item = item_slots[slot_index]
		# old_item.emit_signal("on_dropped", self)
		old_item.remove_entity()

	item_slots[slot_index] = inventory_item
	# 这里发射信号会导致错误，改为直接调用方法
	# inventory_item.emit_signal("on_pickup")
	inventory_item.on_pickup(entity)
	
	# active_item = inventory_item
	self.emit_signal("item_chanage", slot_index, old_item, inventory_item)
	# 获得道具，指定slot
	print_debug("give _item ", inst, " on slot_index: ", slot_index)
	
func remove_selected_item():
	self.remove_item_by_index(self.selected_slot_index)

func remove_item_by_index(item_index:int):
	if item_slots[item_index] == null:
		print_debug("cannot remove item in : " , item_index)
		return
	var item : InventoryItemComponent = item_slots[item_index]
	item.remove_entity()
	item_slots[item_index] = null
	self.emit_signal("item_chanage",item_index, item, null)
	# item.emit_signal("on_remove",self)
	# if item.has("on_remove"):
	# 	item.on_remove()

func modify_item_amount(slot_index, modify_amount):
	var item : InventoryItemComponent = item_slots[slot_index]
	var old_item = item
	if item:
		if item.item_count <= 1:
			remove_item_by_index(slot_index)
		else:
			item.item_count += modify_amount
			emit_signal("item_chanage", slot_index, old_item, item)

func on_save():
	pass

func drop_item(item, whole_stack = true, randomdir = true, pos = Vector2.ZERO):
	if not item or not item.components["inventory_item"] :
		return
	
	var dropped = item.components["inventory_item"].remove_from_owner(whole_stack) or item
	
	if dropped :
		var this_pos = self.inst.position
		# print("Inventory:DropItem", item, pos)
		dropped.position = this_pos
		
		if dropped.components["inventory_item"]:
			dropped.components["inventory_item"].on_dropped(randomdir)

		self.owner.emit_signal("drop_item", {item = dropped})
	return dropped

func drop_everything(on_death:bool,keep_equip:bool):
	if self.active_item :
		self.drop_item(self.active_item)
		self.active_item = null
	for k in range(self.max_slots):
		var v = self.item_slots[k]
		if v :
			self.drop_item(v,true,true)
	if not keep_equip :
		for k in self.equip_slots:
			var v = equip_slots[k]
			if not on_death or not v.components["inventory_item"].keep_on_death :
				self.drop_item(v,true,true)

func use_selected_item():
	var selected_item : InventoryItemComponent = self.item_slots[self.selected_slot_index]
	if not selected_item:
		printerr("cannot found item in this slot")
		return
	selected_item.on_used(self.entity)

func equip_has_tag(tag : String) -> bool:
	for k in self.equip_slots:
		if self.equip_slots[k].is_in_group(tag):
			return true
	return false

# func get_active_item() -> InventoryItemComponent:
# 	return active_item

# func set_active_item(item : InventoryItemComponent):
# 	if item :
# 		# owner.emit_signal("newactiveitem", {item=item})
# 		print_debug("set active item: ", item)
# 		item.emit_signal("on_active_item")
# 	else:
# 		# self.drop_item(item, true, true)
# 		print_debug("can not set active item null !")
# 	# active_item = item

func swap_item(old_slot_index,new_slot_index):
	var c = self.item_slots[old_slot_index]
	self.item_slots[old_slot_index] = self.item_slots[new_slot_index]
	self.item_slots[new_slot_index] = c
	self.emit_signal("item_swap", old_slot_index, new_slot_index)

func stack_item(old_item:InventoryItemComponent,new_item:InventoryItemComponent) -> InventoryItemComponent:
	if not old_item.is_type_identical(new_item):
		printerr("can not stack item becouse its different!")
		return null
	var max_stack : int = old_item.item_resource.max_stacked
	var old_item_count : int = old_item.item_count
	var new_item_count : int = new_item.item_count
	if old_item_count >= max_stack:
		printerr("can not stack item becouse its max!")
		return null
	var residue_count = old_item_count + new_item_count - max_stack
	old_item.item_count = old_item_count + new_item_count
	if residue_count > 0:
		new_item.item_count = residue_count
		return new_item
	else:
		return null

func get_all_items() -> Array:
	var _items = []
	for slot in self.item_slots:
		if slot != null:
			_items.append(slot)
	return _items

func get_item_with_component(component_name : String) -> Array:
	var _items = []
	for item in get_all_items():
		if item.owner.has_component(component_name):
			_items.append(item)
	return _items

func get_item_with_tag(tag_name : String) -> Array:
	var _items = []
	for item in get_all_items():
		if item.owner.has_tag(tag_name):
			_items.append(item)
	return _items
