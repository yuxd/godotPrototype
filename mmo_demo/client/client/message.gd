class_name Message

extends Reference

var DataLen : int # 消息的长度
var ID   :   int # 消息的ID
var Data : PoolByteArray # 消息的内容

# GetDataLen 获取消息数据段长度
func GetDataLen() -> int:
	return self.DataLen

# GetMsgID 获取消息ID
func GetMsgID() -> int:
	return self.ID

# GetData 获取消息内容
func GetData() -> PoolByteArray:
	return self.Data

# SetDataLen 设置消息数据段长度
func SetDataLen(data_len : int) :
	self.DataLen = data_len

# SetMsgID 设计消息ID
func SetMsgID(msgID : int):
	self.ID = msgID

# SetData 设计消息内容
func SetData(data : PoolByteArray):
	self.Data = data
