package main

import (
	"fmt"

	"github.com/aceld/zinx/ziface"
	"github.com/robertkrimen/otto"
)

func OnConnectionAdd(conn ziface.IConnection) {
	fmt.Println("=====> Player PidID = ", " arrived ====")

}

func OnConnectionLost(conn ziface.IConnection) {
	fmt.Println("====> Player ", " left =====")
}

func main() {
	// 创建一个服务器句柄
	// s := znet.NewServer()
	vm := otto.New()
	vm.Set(
		"twoPlus", func(call otto.FunctionCall) otto.Value {
			right, _ := call.Argument(0).ToInteger()
			result, _ := vm.ToValue(2 + right)
			return result
		})
	vm.Run(`
		var t = twoPlus(1)
		console.log(t)
	`)

	// // 注册客户端链接 建立和丢失的HOOK处理函数
	// s.SetOnConnStart(OnConnectionAdd)
	// s.SetOnConnStop(OnConnectionLost)

	// // 注册路由
	// s.AddRouter(1, &api.Login{})

	// // 运行服务器
	// s.Serve()
}

func newVM() *otto.Otto {
	vm := otto.New()
	return vm
}
