package main

import (
	"fmt"
	"github.com/aceld/zinx/ziface"
	"github.com/aceld/zinx/znet"
)

func OnConnectionAdd(conn ziface.IConnection) {
	fmt.Println("=====> Player PidID = ", " arrived ====")

}

func OnConnectionLost(conn ziface.IConnection) {
	fmt.Println("====> Player ", " left =====")
}

func main() {
	// 创建一个服务器句柄
	s := znet.NewServer()

	// 注册客户端链接 建立和丢失的HOOK处理函数
	s.SetOnConnStart(OnConnectionAdd)
	s.SetOnConnStop(OnConnectionLost)

	// 运行服务器
	s.Serve()
}
