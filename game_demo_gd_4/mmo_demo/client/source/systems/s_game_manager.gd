extends System
class_name GameManagerSystem

func _init():
	system_name = "S_GameManager"
	requirements = ["C_GameMode"]

func _system_ready() -> void:
	game_init()
	
func _system_process(_entities: Array, _delta: float) -> void:
#	var game_mode : GameModeComponent = _entities[0].get_component("C_GameMode")
#	print(game_mode.game_mode)
	pass

func game_init():
#	var current_scene := GameInstance.get_current_scene()
#	GameInstance.create_player_character(current_scene)
	pass
