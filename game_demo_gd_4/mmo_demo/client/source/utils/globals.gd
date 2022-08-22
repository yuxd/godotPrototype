extends Node

enum InputAction { MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, JUMP }
const INPUT_TPS := 20

const component_path : String = "res://source/components/"
const entity_path : String = "res://source/entities/"
const system_path : String = "res://source/systems/"
const widget_path : String = "res://source/widget/"

func _ready():
	Console.add_command("say_hello", self, 'print_hello')\
		.set_description("Print Hello %name%!")\
		.add_argument('name', TYPE_STRING)\
		.register()


func print_hello(name : String) -> void:
	Console.write_line("Hello " + name + "!")
