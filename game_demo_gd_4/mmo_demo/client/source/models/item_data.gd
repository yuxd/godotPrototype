extends Resource
class_name ItemData

enum ItemType{
	none,
	item,
	equip
}

@export var ID : String = ""
@export var name : String= "item name"
@export var type : ItemType = ItemType.none
@export var describe : String = "如果你看到这段文字，证明 item 没有正确加载"
@export var icon : Texture = null
@export var can_stack : bool = false
@export var max_stacked :int = 20 # 最大堆叠上限，如果can_stack = false 则无效
