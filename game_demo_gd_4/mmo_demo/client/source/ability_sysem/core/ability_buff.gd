extends Node
class_name AbilityBuff

var _creator 
var _target
var buff_config : BuffConfig
var effects : Array
var current_overlay : int = 1
var max_limit_time : int = 5 # 最大持续时间
#var duration_timer : Timer = Timer.new()
var time_left : float = 0

func initialize_by_config(buff_config : BuffConfig, creator, target):
	self.buff_config = buff_config
	self._creator = creator
	self._target = target
	print_debug(creator ,"创建 buff: ", self, " 作用于： ", target)

func _ready():
	match buff_config.duration_type:
		BuffConfig.DURATION_TYPE.immediately:
			_execute()
			_on_finished()
		BuffConfig.DURATION_TYPE.durationTime:
			max_limit_time == buff_config.duration_arg1
	#		duration_timer.wait_time = max_limit_time
			time_left = max_limit_time
	#		add_child(duration_timer)
	#		duration_timer.connect("timeout", self, "_on_finished")
	#		duration_timer.start()
			_execute()	
		BuffConfig.DURATION_TYPE.permanent:
			print_debug("BuffConfig.DURATION_TYPE.permanent")
		_:
			assert(false)
		
func _exit_tree():
	print_debug("buff _exit_tree: ", self)
	if buff_config.duration_type is BuffConfig.DURATION_TYPE.durationTime:
		for item in effects:
			item.disapply_action()

func _physics_process(delta):
		if buff_config.duration_type is BuffConfig.DURATION_TYPE.durationTime:
			_update(delta)

func _execute():
	"""Buff触发"""
	apply_effect()

func _update(delta):
	"""Buff持续"""
#	apply_effect()
	time_left = time_left - delta
	if time_left <= 0:
		_on_finished()

func _on_finished():
	"""重置Buff用"""
	_end_buff()

func _on_refresh():
	"""刷新，用于刷新Buff状态"""
	if buff_config.duration_type is BuffConfig.DURATION_TYPE.durationTime:
#		duration_timer.wait_time = max_limit_time
		time_left = max_limit_time

func _activate():
	"""激活"""
	pass

func _end_buff():
	"""结束"""
	print_debug("_end_buff : ", self )
	call_deferred("queue_free")

func apply_effect():
	"""应用能力效果"""
	for effect_config in buff_config.effects:
		var effect = _creator.apply_effect_by_config_name(effect_config, _target)
		effects.append(effect)
