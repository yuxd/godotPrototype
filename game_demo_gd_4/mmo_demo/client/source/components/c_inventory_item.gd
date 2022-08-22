extends Node
class_name InventoryItemComponent

var component_name = "C_InventoryItem"
var inst : Entity

# export (Resource) var _item_resource = null
@export var item_ID := ""
@export var item_name : String= "item name"
@export var item_icon : Texture = null
@export var can_stack : bool = false
@export var item_type : String = "item type"
@export var item_describe : String = "如果你看到这段文字，证明 item 没有正确加载"
@export var max_stacked :int = 20 # 最大堆叠上限，如果can_stack = false 则无效
var item_count : int = 1
var can_pickup : bool = false
# signal on_pickup(Initiator)
# signal on_active_item(Initiator)
# signal on_dropped(Initiator)
# signal on_put_in_inventory(Initiator)
# signal on_remove(Initiator)
signal on_used(Initiator)

func init_by_resource(res : Resource):
	if res == null or not res is ItemData:
		assert(false)
	item_ID = res.item_ID
	item_name = res.item_name
	item_icon = res.item_icon
	can_stack = res.can_stack
	item_type = res.item_type
	item_describe = res.item_describe
	max_stacked = res.max_stacked

func init_by_dic(data: Dictionary):
	pass

# func get_item_resource() -> Resource:
# 	if not _item_resource is ItemResource:
# 		printerr(_item_resource ," is not item resource!")
# 		return null
# 	else:
# 		return _item_resource
		
# func get_max_stacked() -> int:
# 	if self._item_resource is ItemResource:
# 		return max_stacked
# 	else:
# 		printerr("_item_resource is not ItemResource")
# 		return -1

# func can_stacked() -> bool:
# 	# if not self.get_item_resource():
# 	# 	printerr("can not found item resource, ", self.name)
# 	# 	return false
# 	return can_stack

func is_type_identical(item : InventoryItemComponent) -> bool:
	return self.item_name == item.item_name

func _to_string():
	return "inventory item name set to: " + String(self.item_name)

func set_can_pickup(value):
#	var inspect = entity.get_component("inspectable")
#	if inspect and inspect.is_inspect == true:
#		if value == true:	
#			inspect.set_pickable_cursor()
#		else:	
#			inspect.set_forbidden_cursor()
	can_pickup = value

func on_dropped(randomdir):
	pass

# If this func retrns true then it has destroyed itself and you shouldnt give it to the player
func on_pickup(pickup_guy):
	# print_debug("item: ",self,"on pickup")
	if pickup_guy != QInstance.get_player_character() :
		# ProfileStatsAdd("collect_"..self.inst.prefab)
		printerr("pickup guy is not player character!")
		# return
	inst.hide()
	# self.inst.position = Vector2(0,0)
	# self.inst:PushEvent("onpickup", {owner = pickupguy})
	# var component_manager : EntityBase = owner.component_manager
	# var pickup_guy_inventory = pickup_guy.get_component("inventory")
	# var is_success : bool = pickup_guy_inventory.give_item_empty_slot(self.owner)
	# if is_success:

func _item_name_get() -> String:
	return item_name
	
func _item_ID_get() -> String:
	return item_ID
