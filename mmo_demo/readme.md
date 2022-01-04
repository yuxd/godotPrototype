# mmo-demo



## server 目录结构

- apis 存放基本的用户自定义路由业务，一个msgID对应的一个业务

## 协议

MsgID	协议名	发起方	描述
1	SyncPid	Server	同步玩家本次登录的ID(用来标识玩家)
2	Talk	Client	世界聊天
3	MovePackege	Client	移动
200	BroadCast	Server	广播消息(Tp 1 世界聊天 2 坐标(出生点同步) 3 动作 4 移动之后坐标信息更新)
201	SyncPid	Server	广播消息 掉线/aoi消失在视野
202	SyncPlayers	Server	同步周围的人位置信息(包括自己)
