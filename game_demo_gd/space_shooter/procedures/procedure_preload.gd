# 在这里完成资源的预加载
extends ProcedureBase


var DataTableNames : Array = [
        "Aircraft",
        "Armor",
        "Asteroid",
        "Entity",
        "Music",
        "Scene",
        "Sound",
        "Thruster",
        "UIForm",
        "UISound",
        "Weapon",
    ]

func enter(_msg := {}) -> void:
    _preload_resources()

func _preload_resources() -> void:
    # TODO 加载配置
    var err = QInstance.config.load("res://configs/default.cfg")
    if err != OK:
        printerr(err)

    # 加载数据表
    var datatable_manager = QInstance.get_datatable_manager()
    var datatable_path = "res://datatables/"
    datatable_manager.set_datatable_path(datatable_path)
    for d in DataTableNames:
        datatable_manager.load_datatable(d,datatable_path)
    print(datatable_manager._datatable_dics)

func update(_delta: float) -> void:
    state_machine.transition_to("change_scene")