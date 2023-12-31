extends Node
class_name CameraManagerSystem

const system_name := "S_CameraManager"
var requirements = ["C_Camera"]
var system_manager : SystemManager
var player_cha : Entity
var c_input : InputComponent

var event_player_cha_changed : EventResource = preload("res://source/events/event_player_cha_changed.tres")

func _system_init(_system_manager: SystemManager) -> bool:
	system_manager = _system_manager
	return true


func _system_ready() -> void:
	player_cha = GameInstance.player_character
	if player_cha: c_input = player_cha.get_component("C_Input")
	event_player_cha_changed.subscribe(_on_player_cha_changed)
	print_debug("camera manager system ready")


func _system_process(_entities: Array, _delta: float) -> void:
	if(player_cha == null):
		printerr("player_cha is null!") 
		return
	for e in _entities:
		var camera : CameraComponent = e.get_component("C_Camera")		
		if e.position.distance_to(player_cha.position) >= 5.0:
			e.position = e.position.lerp(player_cha.position, _delta * camera.speed)
#		var mu: float = 1 if c_input.is_action_pressed(Globals.InputAction.MOVE_UP) else 0
#		var md: float = 1 if c_input.is_action_pressed(Globals.InputAction.MOVE_DOWN) else 0
#		camera.zoom += Vector2(md - mu, md - mu)

static func auto_set_limits(camera_entity : Entity) -> void:
	var camera : CameraComponent = camera_entity.get_component("C_Camera")
	camera.limit_left = 0
	camera.limit_right = 0
	camera.limit_top = 0
	camera.limit_bottom = 0
	var tilemaps = camera_entity.get_tree().get_nodes_in_group("tilemap")
	for tilemap in tilemaps:
		if tilemap is TileMap:
			var used = tilemap.get_used_rect()
			camera.limit_left = min(used.position.x * tilemap.cell_size.x, camera.limit_left)
			camera.limit_right = max(used.end.x * tilemap.cell_size.x, camera.limit_right)
			camera.limit_top = min(used.position.y * tilemap.cell_size.y, camera.limit_top)
			camera.limit_bottom = max(used.end.y * tilemap.cell_size.y, camera.limit_bottom)


func _on_player_cha_changed(old_player, new_player) -> void:
	if new_player: c_input = new_player.get_component("C_Input")	
	player_cha = new_player

