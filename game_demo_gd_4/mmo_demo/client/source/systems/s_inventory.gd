extends System
class_name InventorySystem

var event_item_changed : EventResource = load("res://source/events/event_item_changed.tres").new()

signal item_chanage(slot_index, item, new_item)
signal item_swap(old_slot_index, new_slot_index)
signal seleced_slot_change(old_slot_index, new_slot_index)

func _init():
	system_name = "S_Inventory"
	requirements = ["C_Inventory"]

static func add_item(inventory_entity : Entity, item_entity : Entity) -> bool:
	'''
	添加道具
	'''
	if not item_entity.has_component("inventory_item"):
		printerr("connot add item ,it hasnot component inventory_item : ", item_entity.name)
		return false

	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	var item : InventoryItemComponent = item_entity.get_component("C_InventoryItem")
	if item.can_stack:
		var slot = InventorySystem.get_stacked_slot_by_item( inventory_entity, item)
		if slot == -1 :
			return give_item_empty_slot(inventory_entity, item_entity)
		else:
			var current_item : InventoryItemComponent = inventory.item_slots[slot]
			if not current_item.is_type_identical(item) :
				return give_item_empty_slot( inventory_entity, item_entity)
			else:
				# 开始合并道具
				var current_count = current_item.item_count
				var max_count = current_item.max_stacked
				if current_count + item.item_count <= max_count:
					# 直接合并
					item.item_count = current_count + item.item_count
					return give_item(inventory_entity, item_entity, slot)
				else:
					if found_empty_slot(inventory_entity) != -1:
						# 合并之后还多道具
						current_item.item_count = max_count
#						emit_signal("item_chanage",slot,current_item,current_item)
						InventorySystem.event_item_changed.emit([inventory_entity, slot, current_item, current_item])
						item.item_count = item.item_count - max_count + current_count
						return add_item(inventory_entity, item_entity)
					else:
						return false
	else:
		return give_item_empty_slot(inventory_entity, item_entity)

static func found_empty_slot(e : Entity) -> int:
	var inventory : InventoryComponent = e.get_component("C_Inventory")
	var item_slots = inventory.item_slots
	for i in range(item_slots.size()):
		if item_slots[i] == null:
			return i
	# 如果找不到，返回 -1
	return -1

static func get_stacked_slot_by_item(inventory_entity : Entity , item: InventoryItemComponent)-> int:
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	var item_slots = inventory.item_slots
	for i in item_slots.size():
		var slot_item : InventoryItemComponent = item_slots[i]
		if not slot_item:
			break
		if slot_item and slot_item.is_type_identical(item) and slot_item.item_count != slot_item.max_stacked:
			return i
	return -1

static func get_slot_by_item(inventory_entity : Entity, item_entity: Entity) -> int:
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	var item : InventoryItemComponent = inventory_entity.get_component("C_InventoryItem")
	var item_slots = inventory.item_slots
	# 相同类型道具，可以进行 叠加 操作
	for i in item_slots.size():
		var slot_item : InventoryItemComponent = item_slots[i]
		if not slot_item:
			break
		if slot_item and slot_item.is_type_identical(item):
			return i
	return -1

static func found_slot_can_give(inventory_entity : Entity, item_entity : Entity) -> int:
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	var item : InventoryItemComponent = item_entity.get_component("C_InventoryItem")
	if item.item_resource.can_stack and get_slot_by_item(inventory_entity, item_entity) != -1:
		return get_slot_by_item(inventory_entity, item_entity) 
	else:
		return found_empty_slot(inventory_entity)

static func get_item_by_index(inventory_entity : Entity, index:int) -> Entity:
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")	
	if index > inventory.max_slots :
		print_debug("can not get item , max slot :", index)
		return null
	return inventory.item_slots[index]

static func give_item_empty_slot(inventory_entity : Entity, item_entity : Entity) -> bool:
	# 将道具添加到空闲的位置
	var slot = InventorySystem.found_empty_slot(inventory_entity)
	if slot == -1 :
		print_debug("can not found empty slot")
		return false
	give_item(inventory_entity, item_entity, slot)
	return true

static func give_item(inventory_entity : Entity, item_entity : Entity, slot_index : int):	
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	var item : InventoryItemComponent = item_entity.get_component("C_InventoryItem")
	if slot_index > inventory.max_slots :
		print_debug("cannot give item, max slots :" + slot_index)
		return
#	var item : InventoryItemComponent = item_entity.get_component("C_InventoryItem")
	if not item:
		print_debug("can not found C_InventoryItem in : ", item_entity)
		return
	var old_item : InventoryItemComponent = null
	if inventory.item_slots[slot_index] != null:
		# TODO 如果不为空，首先drop 这个位置的道具
		old_item = inventory.item_slots[slot_index]
		# old_item.emit_signal("on_dropped", self)
		old_item.remove_entity()

	inventory.item_slots[slot_index] = item
	# 这里发射信号会导致错误，改为直接调用方法
	# inventory_item.emit_signal("on_pickup")
#	inventory_item.on_pickup(entity)
	
	# active_item = inventory_item
#	emit_signal("item_chanage", slot_index, old_item, inventory_item)
	InventorySystem.event_item_changed.emit([inventory_entity, slot_index, old_item, item_entity])
	# 获得道具，指定slot
	print_debug("give item ", item, " on ", inventory,"slot_index: ", slot_index)


static func remove_selected_item(inventory_entity : Entity):
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	remove_item_by_index(inventory_entity, inventory.selected_slot_index)


static func remove_item_by_index(inventory_entity : Entity, item_index : int):
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")
	if inventory.item_slots[item_index] == null:
		print_debug("cannot remove item in : " , item_index)
		return
	var item : InventoryItemComponent = inventory.item_slots[item_index]
	item.remove_entity()
	inventory.item_slots[item_index] = null
#	self.emit_signal("item_chanage",item_index, item, null)
	InventorySystem.event_item_changed.emit([inventory_entity, item_index, item, null])
	# item.emit_signal("on_remove",self)
	# if item.has("on_remove"):
	# 	item.on_remove()

static func modify_item_amount(inventory_entity : Entity, slot_index : int, modify_amount : int) -> void:
	var inventory : InventoryComponent = inventory_entity.get_component("C_Inventory")	
	var item : InventoryItemComponent = inventory.item_slots[slot_index]
	var old_item = item
	if item:
		if item.item_count <= 1:
			remove_item_by_index(inventory_entity, slot_index)
		else:
			item.item_count += modify_amount
#			emit_signal("item_chanage", slot_index, old_item, item)
			InventorySystem.event_item_changed.emit([inventory_entity, slot_index, old_item, item])

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
			var v = self.equip_slots[k]
			if not on_death or not v.components["inventory_item"].keep_on_death :
				self.drop_item(v,true,true)


func use_selected_item():
	var selected_item : InventoryItemComponent = self.item_slots[self.selected_slot_index]
	if not selected_item:
		printerr("cannot found item in this slot")
		return
#	selected_item.on_used(self.entity)


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

