extends BTLeaf
class_name BTChifan

func run() -> void:
	# 判断当前是否饥饿, 否返回失败
	if owner.b_jie == false:
		printerr("当前不饿！")				
		completed.emit(fail())
		return
	# 是饥饿，则定时2秒钟，将饥饿状态改为F，返回成功
	else :
		printerr("当前很饿，开始吃饭！")		
		await get_tree().create_timer(2).timeout
		printerr("吃饱了！")	
		owner.b_jie = false
		completed.emit(succeed())
		return
