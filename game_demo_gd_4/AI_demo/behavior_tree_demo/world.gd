extends Node2D

@onready var player := $Player

var lefe_progress_bar = $form_main/ProgressBar


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	lefe_progress_bar.value = player.life
