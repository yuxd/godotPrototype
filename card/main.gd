extends CanvasLayer

onready var arrow = $arrow

var dragging = false
var click_pisition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	if dragging:
		arrow.reset(click_pisition,get_viewport().get_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
			click_pisition =  event.position
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
