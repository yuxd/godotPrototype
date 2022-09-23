extends Node2D

@onready var player := $Player
@onready var icon_held : TextureRect = $form_main/icon_held
var lefe_progress_bar = $form_main/ProgressBar


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	lefe_progress_bar.value = player.life


func update_held_icon():
	if player.held == null:
		icon_held.visible = false
	else:
		icon_held.visible = true
		icon_held.texture = load("res://assets/" + player.held.get_object_type()+".tres")
