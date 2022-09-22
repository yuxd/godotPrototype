extends BTLeaf
class_name BTShuijiao

func run() -> void:
	# 判断当前是否饥饿, 否返回失败
	if owner.b_kun == false:
		printerr("当前不困！")				
		completed.emit(fail())
		return
	# 是饥饿，则定时2秒钟，将饥饿状态改为F，返回成功
	else :
		printerr("当前很困，开始睡觉！")		
		await get_tree().create_timer(1).timeout
		printerr("睡醒了！")	
		owner.b_kun = false
		completed.emit(succeed())
		return
