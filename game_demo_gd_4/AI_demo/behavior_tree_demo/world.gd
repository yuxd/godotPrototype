extends Node2D
class_name World

@onready var player : PlayerCharacter = $Player
@onready var lefe_progress_bar : ProgressBar = $form_main/ProgressBar
@onready var label_wood_amount : Label = $form_main/Panel/HBoxContainer/wood_amount
var game_objects : Array = []


func _ready() -> void:
	seed(Time.get_unix_time_from_system())
	game_objects.append($box)
	var tree_positions = PackedVector2Array()
	for i in range(5):
		var tree = preload("res://behavior_tree_demo/tree.tscn").instantiate()
		while true:
			var p = Vector2((randf_range(0.2,0.8)) * 576.0, (randf_range(0.2,0.8)) * 328.0)
			var ok = true
			for t in tree_positions:
				if (p-t).length() < 3:
					ok = false
					break
			if ok:
				tree.position = Vector2(p.x, p.y)
				tree_positions.append(p)
				break
		add_child(tree)
		game_objects.append(tree)
		tree.set_grown()
#	player.run_to($box)


func _process(delta: float) -> void:
	lefe_progress_bar.value = player.life
	label_wood_amount.text = str($box.count)
