extends Label

func _physics_process(delta):
	var day = String(GameInstance.get_time_manager().get_day())
	var hour = String(GameInstance.get_time_manager().get_hour())
	self.text = "第" + day +"天，"+ hour + "小时"
