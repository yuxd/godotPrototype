package api

import (
	"fmt"
	"github.com/aceld/zinx/ziface"
	"github.com/aceld/zinx/znet"
)

type Login struct {
	znet.BaseRouter
}

func (*Login) Handle(request ziface.IRequest) {
	msg := string(request.GetData())
	fmt.Println(msg)
}
