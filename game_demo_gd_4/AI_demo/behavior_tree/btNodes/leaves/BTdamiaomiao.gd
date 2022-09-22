extends BTLeaf
class_name BTDamiaomiao

func run() -> void:
	await get_tree().create_timer(1).timeout
	var r := randf()
	if r >= 0.5 :
		print("打苗苗成功！")
		completed.emit(succeed())
		return
	else:
		print("打苗苗失败！")
		completed.emit(fail())
		return
