# 提供场景管理的功能，可以同时加载多个场景，也可以随时卸载任何一个场景，从而很容易地实现场景的分部加载
extends Node
class_name SceneManager

var current_scene : SceneBase = null : set = _current_scene_setter
@onready var canvas_layer = $CanvasLayer
var scene_path = "res://scripts/tiles/"

var _scenes = {}

signal current_scene_changed(scene)
signal scene_loaded(scene)

func goto_scene(scene_name, msg: Dictionary = {}):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	#这个函数通常会从一个信号回调、
	#或当前场景中的其他函数中调用。此时删除当前场景不是一个好主意，
	#因为它可能仍在执行代码。这将导致崩溃或意外行为。
	#解决方案是将加载延迟到稍后的时间，此时我们可以确保当前场景中没有代码在运行
	call_deferred("_deferred_goto_scene", scene_name, msg)

func _deferred_goto_scene(scene_name, msg: Dictionary = {}):
	# It is now safe to remove the current scene
	#现在可以安全地移除当前场景了
	var path = scene_path + scene_name + ".tscn"
	if current_scene:
		# current_scene.queue_free()
		current_scene.hide()
		current_scene._exit()
	
	var s = null
	if scene_name in _scenes:
		current_scene = _scenes[scene_name]
	else:
		s = ResourceLoader.load(path)
		#实例化新场景。
		if s :
			current_scene = s.instance()
		# Add it to the active scene, as child of root.
		# 将它添加到活动场景中，作为根的子级。
		# get_tree().get_root().add_child(current_scene)
		if QInstance.main_node != null:
			QInstance.main_node.add_child(current_scene)
		_scenes[scene_name] = current_scene
	self.emit_signal("current_scene_changed", current_scene)
	QInstance.current_scene = current_scene
	
	current_scene.show()
	current_scene._enter(msg)
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	#（可选）使其与SceneTree.change_scene（）API兼容。
	get_tree().set_current_scene(current_scene)

# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	if !current_scene:
		return
		current_scene.handle_input(event)

func _process(delta: float) -> void:
	if !current_scene:
		return
	current_scene._update(delta)

func _physics_process(delta: float) -> void:
	if not current_scene:
		return
	current_scene._physics_update(delta)

func has_scene(scene_name):
	return _scenes.has(scene_name)

func get_scene(scene_name):
	return _scenes[scene_name]

func load_scene(scene_name: String , scene_ID : String = "") -> SceneBase:
	var res_loader = ResourceAsyncLoader.new()
	var res_paths = []
	res_paths.append(scene_path + scene_name + ".tscn")
	var res = await res_loader.load_start.bind(res_paths)
	assert(res[0])
	var scene = res[0].instance()
	if not scene:
		print_debug("create scene faild! scene load name : ", scene_name)
	else:
		if scene_ID == "":
			_scenes[scene_name] = scene
		else:
			_scenes[scene_ID] = scene
			scene.name = scene_ID
		QInstance.main_node.add_child(scene)
		scene.hide()
	self.emit_signal("scene_loaded",scene)
	return scene

func _current_scene_setter(value) -> void:
	self.emit_signal("current_scene_changed",value)
	print_debug("_current_scene_setter: ", value)
	current_scene = value
