extends Node
class_name RefreshableComponent

const component_name = "C_Refreshable"

@export var refresh_inverval : int = 10 # 单位秒
var time_left := 0

@export var subordinate_count : int = 1 # -1代表不限数量
var subordinates : Array = []

@export var subordinate_random_pool : Array = []
@export var subordinate_random_widget : PackedInt32Array = []

var _total_widget : int = 0

func _ready():
	for w in subordinate_random_widget:
		_total_widget += w

func can_refresh() -> bool:
	if subordinate_count < get_subordinate_count() or subordinate_count == -1 :
		return true
	return false
	
func get_subordinate_count() -> int:
	var count : int = 0
	for s in subordinates:
		if s == null:
			subordinates.erase(s)
		else:
			count += 1
	return count

func get_random_subordinate() -> PackedScene:
	var r = randi_range(0, _total_widget)
	var widget := 0
	for i in subordinate_random_widget.size():
		var w = subordinate_random_widget[i] + widget
		if r <= w:
			return subordinate_random_pool[i]
	return null
	
