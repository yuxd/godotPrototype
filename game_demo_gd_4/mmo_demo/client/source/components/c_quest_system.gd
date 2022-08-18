extends Node
class_name QuestSystemComponent

var component_name := "c_quest_system"
var inst_id := ""
var data : QuestData = null

func _init():
	printerr("测试 _init 是否添加成功")

func _enter_tree():
	printerr("测试 _enter_tree 是否添加成功")

func _ready():
	printerr("测试 _ready 是否添加成功")

func _exit_tree():
	printerr("测试 _exit_tree 是否添加成功")
