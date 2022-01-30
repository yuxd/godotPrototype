# 这里完成场景切换，需要用到场景管理器，异步加载、卸载场景

extends ProcedureBase

var _change_to_menu : bool = true
var _is_change_scene_complete : bool = true
const _menu_sceneID : int = 1

func enter(_msg := {}) -> void:
	if _msg.has("_change_to_menu"):
		_change_to_menu = _msg["_change_to_menu"]

func update(_delta: float) -> void:
	if not _is_change_scene_complete:
		return
	if _change_to_menu:
		change_state("menu")
	else:
		change_state("main")
