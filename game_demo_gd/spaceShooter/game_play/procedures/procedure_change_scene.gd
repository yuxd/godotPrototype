# 这里完成场景切换，需要用到场景管理器，异步加载、卸载场景

extends ProcedureBase

var _change_to_menu : bool = false
var _is_change_scene_complete : bool = false
const _menu_sceneID : int = 1

func enter(_msg := {}) -> void:
    pass

func update(_delta: float) -> void:
    if not _is_change_scene_complete:
        return
    if _change_to_menu:
        change_state("menu")
    else:
        change_state("main")