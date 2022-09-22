extends BTLeaf
class_name BTDadoudou

func run() -> void:
	await get_tree().create_timer(1).timeout
	var e := randf()
	owner.b_jie = true if e >= 0.5 else false
	var k := randf()
	owner.b_kun = true if k >= 0.5 else false
	var r := randf()
	if r >= 0.5 :
		print("打豆豆成功！")
		completed.emit(succeed())
		return
	else:
		print("打豆豆失败！")
		completed.emit(fail())
		return
