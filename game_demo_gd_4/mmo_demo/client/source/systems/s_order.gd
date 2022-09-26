extends System
class_name OrderSystem

func _init():
	system_name = "S_Order"
	requirements = ["C_Order"]

# 周期性创建订单
func _ready():
	GameInstance.create_order()

# 完成订单

# 管理订单状态
