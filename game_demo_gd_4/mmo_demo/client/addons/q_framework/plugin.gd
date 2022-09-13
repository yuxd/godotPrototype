@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("QInstance", "res://addons/q_framework/q_instance.tscn")
#	add_autoload_singleton("EntityManager", "res://addons/q_framework/entities/manager_entity.tscn")

func _exit_tree():
	remove_autoload_singleton ("QInstance")
#	remove_autoload_singleton("EntityManager")
