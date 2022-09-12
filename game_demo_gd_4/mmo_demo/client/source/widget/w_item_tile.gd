extends Control
class_name ItemTile

@onready var img_item = $CenterContainer/img_item
@onready var lab_item_count = $lab_item_count

var inventory_item : InventoryItemComponent = null
var slot_index : int = 0
var b_dragging : bool = false

func _ready():
	self.hide()

func show_tile(new_item : ):	
	self.inventory_item = new_item
	if new_item == null:
		self.hide()
		lab_item_count.hide()
	else:
		self.show()
		# var item_resource : ItemResource = new_item.get_item_resource()
		# if not item_resource:
		# 	printerr("can not get item resource,", new_item.name)
		# 	return
		img_item.texture = new_item.item_icon
		if new_item.can_stack :
			lab_item_count.show()
		else:
			lab_item_count.hide()
		lab_item_count.text = str(new_item.item_count)
