extends Node2D

onready var label_score = $Control/L_Score

onready var scene_root = $SceneRoot
var t_scene = load("res://Scene.tscn")

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = t_scene.instance()
	var s2 = t_scene.instance()
	s2.position.x = 1023
	scene_root.add_child(s)
	scene_root.add_child(s2)


	


func _on_Timer_timeout():
	score += 1
	print("score:", score)
	# label_score.text = String(sorce)
