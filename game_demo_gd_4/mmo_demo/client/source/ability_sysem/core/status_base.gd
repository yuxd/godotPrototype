extends AbilityAttribute
class_name AbilityStatus

var current_value : int = 0
var max_value : int setget , _max_value_getter
var _max_value_attribute : AbilityAttribute

func reset() -> void:
	assert(max_value != null)
	current_value = max_value
	
func set_max_value_attribute(attribute: AbilityAttribute) -> void:
	_max_value_attribute = attribute
#	reset()
	current_value = _max_value_attribute.value
	
func minus(minus_value : int) -> void:
	self.current_value = max(0, self.current_value - minus_value)

func add(add_value : int) -> void:
	var v = min(max_value, current_value + add_value)
	self.current_value = v

func percent() -> float:
	var v : float = current_value / max_value
	return v

func _max_value_getter():
	if (_max_value_attribute == null) : return null
	return _max_value_attribute.value
