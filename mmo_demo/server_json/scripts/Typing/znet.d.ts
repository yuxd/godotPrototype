declare module "ZNet"{
    interface IServer{
        Start()		//启动服务器方法
        Stop() 		//停止服务器方法
        Serve() 	//开启业务服务方法
        AddRouter(msgID : int, router IRouter) //路由功能：给当前服务注册一个路由业务方法，供客户端链接处理使用
        GetConnMgr() IConnManager 				//得到链接管理
        SetOnConnStart(func(IConnection)) 		//设置该Server的连接创建时Hook函数
        SetOnConnStop(func(IConnection)) 		//设置该Server的连接断开时的Hook函数
        CallOnConnStart(conn IConnection) 		//调用连接OnConnStart Hook函数
        CallOnConnStop(conn IConnection) 		//调用连接OnConnStop Hook函数
        Packet() Packet
    }
}