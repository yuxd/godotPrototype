extends Control

onready var lab_item_name = $lab_item_name
onready var lab_item_type = $lab_item_type
onready var lab_item_describe = $lab_item_describe
onready var animation_player = $AnimationPlayer

func _ready():
#	self.show()
	self.rect_pivot_offset = self.rect_size/2
	
func set_item_info(item):
	self.lab_item_name = item.item_name
	self.lab_item_type = item.item_type
	self.lab_item_describe = item.item_describe

func show():
	if self.visible == false:
		.show()
	animation_player.play("on_show")

func hide():
	animation_player.play("on_hide")	

func set_info(inventory_item: InventoryItemComponent):
#	var inventory_item : InventoryItemComponent = object.get_component("inventory_item")
	if not inventory_item:
		print_debug("inventory item is null")
		return
	# var res_item : ItemResource = inventory_item.get_item_resource()
#	assert(res_item as ItemResource)
	# if res_item:
	self.lab_item_name.text = inventory_item.item_name
	self.lab_item_type.text = inventory_item.item_type
	self.lab_item_describe.text = inventory_item.item_describe
