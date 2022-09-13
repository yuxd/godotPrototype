package main

import (
	"fmt"
	"server_json/api"

	"github.com/aceld/zinx/ziface"
	"github.com/aceld/zinx/znet"
)

func OnConnectionAdd(conn ziface.IConnection) {
	fmt.Println("=====> Player PidID = ", conn.GetConnID(), " arrived ====")

}

func OnConnectionLost(conn ziface.IConnection) {
	fmt.Println("====> Player ", conn.GetConnID(), " left =====")
}

func main() {
	// 创建一个服务器句柄
	s := znet.NewServer()

	// 注册客户端链接 建立和丢失的HOOK处理函数
	s.SetOnConnStart(OnConnectionAdd)
	s.SetOnConnStop(OnConnectionLost)

	// 注册路由
	s.AddRouter(1, &api.Login{})

	// 运行服务器
	s.Serve()
}
