# 自定义资源
extends Resource
class_name EventResource # , 'res://EventResource/event_icon.svg'

# 自定义信号
signal custom_event( type, message)
signal custom_action(invobject,target,doer,message)
# 可以定义一些属性
@export var type := 'defaultEvent'
# export(PackedScene) var invobject = null
# export(PackedScene) var target = null
# export(PackedScene) var doer = null

# 自定义方法用于发送信号的包装，也可以直接发送信号
func emit_custom_signal(object) -> void:
	self.emit_signal('custom_event', type, object)

func subscribe_signal(object, subscribe_func : Callable):
	self.connect("custom_event",object.subscribe_func)

func unsubscribe_signal(object, subscribe_func : Callable):
	self.disconnect("custom_event",object.subscribe_func)

#func push_action(p_invobject = null, p_target = null, p_doer = null, p_message= {}):
#	# invobject = p_invobject
#	# target = p_target
#	# doer = p_doer
#	self.emit_signal('custom_action', p_invobject, p_target, p_doer, p_message)
#
#func subscribe_action(p_invobject = null, p_target = null, p_doer = null, p_message= {}):
#	self.connect('custom_action', p_invobject.p_target.bind(p_doer, p_message))
