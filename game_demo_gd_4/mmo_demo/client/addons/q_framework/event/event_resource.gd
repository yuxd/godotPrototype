# 自定义资源
extends Resource
class_name EventResource # , 'res://EventResource/event_icon.svg'

# 自定义信号
signal custom_event
# signal custom_action(invobject,target,doer,message)
@export var destination : String = ""

# Emits a payload to a destination. Any subscribed components will receive the payload
func emit(payload) -> void:
	print_debug("EventReource emit: ", self.resource_name, " - ",self.destination)
	if not payload is Array:
		payload = [payload]
	payload.insert(0, get_destination_signal())
	callv("emit_signal", payload)


func unsubscribe(unsubscribe_func : Callable):
	print_debug("EventReource unsubscribe: ", self.resource_name, " - ", self.destination)	
	var dest_signal : String = get_destination_signal()
	if is_connected(dest_signal, unsubscribe_func):
		disconnect(dest_signal, unsubscribe_func)


# Subscribes to a destination. callback_name is the method to be called.
func subscribe(callback : Callable):
	print_debug("EventReource subscribe: ", self.resource_name, " - ", self.destination)
	var dest_signal: String = get_destination_signal()
	if not is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		connect(dest_signal, callback)


func get_destination_signal() -> String:
	var dest_signal: String = "EventBus|%s" % destination
	if not has_user_signal(dest_signal):
		add_user_signal(dest_signal)
	return dest_signal
