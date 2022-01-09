package main

import (
	"github.com/aceld/zinx/znet"
)

func main() {
	// 创建server句柄
	s := znet.NewServer()

	// 链接、创建和销毁的hook函数

	// 注册路由

	// 启动服务
	s.Start()
}
