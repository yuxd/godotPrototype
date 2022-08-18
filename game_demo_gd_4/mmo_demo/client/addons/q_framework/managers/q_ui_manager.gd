# 提供管理界面和界面组的功能，如显示隐藏界面、激活界面、改变界面层级等。不论是 Unity 内置的 uGUI 还是其它类型的 UI 插件（如 NGUI），只要派生自 UIFormLogic 类并实现自己的界面类即可使用。界面使用结束后可以不立刻销毁，从而等待下一次重新使用
extends Node
class_name UIManager

var form_path = "res://scripts/user_interfaces/forms/"
var widget_path = "res://scripts/user_interfaces/widgets/"

var forms := {}
var widgets := {}

@onready var canvas_layer = $CanvasLayer
@onready var canvas_layer_pop = $CanvasLayer_pop
@onready var canvas_layer_dialogic = $CanvasLayer_dialogic

var current_form : Control = null

enum UITYPE{
	form,
	pop,
	dialog,
}

func init_ui_manager(form_path : String, widget_path : String) -> void:
	self.form_path = form_path
	self.widget_path = widget_path

func show_form(form_name : String, form_owner : Object, ui_type = UITYPE.form) -> Control:
	if self.forms.has(form_name):
		var form = self.forms[form_name]
		form.show()
		self.current_form = form
		return form
	else:
		var _form_path = self.form_path + form_name + ".tscn"
		if not ResourceLoader.exists(_form_path):
			printerr("cannot load ui scene: ", _form_path)
			return null
		var _ui_scene = load(_form_path)
		var ui_instance = _ui_scene.instantiate()
		if "form_owner" in ui_instance:
			ui_instance.form_owner = form_owner
		match ui_type:
			UITYPE.form:
				canvas_layer.add_child(ui_instance)
				self.forms[form_name] = ui_instance
				self.current_form = ui_instance
			UITYPE.pop:
				canvas_layer_pop.add_child(ui_instance)
			UITYPE.dialog:
				canvas_layer_dialogic.add_child(ui_instance)
		return ui_instance

func remove_form_by_name(form_name :String):
	if self.forms.has(form_name):
		self.forms[form_name].hide()

func hide_all_form():
	for k in self.forms:
		var form = self.forms[k]
		form.hide()

func remove_form(form):
	form.hide()

func hide_current_form():
	current_form.hide()
	var form_name := ""
	for i in self.forms.values().size():
		if self.forms.values().size() >= 2 and current_form == self.forms.values()[i]:
			current_form = self.forms.values()[i-1]
			show_current_form()

func show_current_form():
	for k in self.forms:
		var form = self.forms[k]
		form.hide()
	current_form.show()

func get_form_name(form) -> String:
	for k in forms:
		if form == self.forms[k]:
			return k
	return ""

func pop_widget(widget_name : String) -> Control:
	var _widget = null
	if widget_name in widgets:
		_widget = widgets[widget_name]
	else:
		_widget = load(self.widget_path + widget_name + ".tscn").instance()
		self.canvas_layer_pop.add_child(_widget)
		widgets[widget_name] = _widget
	_widget.show()
	return _widget

#func show_dialog(dialog_name : String) :
#	var new_dialog = Dialogic.start(dialog_name)
#	self.add_child(new_dialog)
