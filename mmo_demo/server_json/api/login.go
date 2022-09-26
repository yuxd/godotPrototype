package api

import (
	"encoding/json"
	"fmt"
	"github.com/aceld/zinx/ziface"
	"github.com/aceld/zinx/znet"
	"server_json/core"
	"server_json/message"
)

type Login struct {
	znet.BaseRouter
}

func (*Login) Handle(request ziface.IRequest) {
	msg := string(request.GetData())
	fmt.Println(msg)

	info := message.LoginInfo{}
	err := json.Unmarshal(request.GetData(), &info)
	if err != nil {
		fmt.Println(err)
		return
	}
	//fmt.Println(info.UserName)
	if canLogin(info) {
		acount := core.NewAcount(info.UserName, request.GetConnection())
		request.GetConnection().SetProperty("Acount", acount)
		d := &message.RspLogin{
			CanLogin: true,
		}
		acount.SendMessage(101, d)
	} else {

	}
}

func canLogin(info message.LoginInfo) bool {
	// 正常处理这里需要跟第三方sdk或者数据库交互，这里教学目的，所以省略
	userInfoMap := make(map[string]string)
	userInfoMap["weimin"] = "12345"
	userInfoMap["weimin2"] = "1"

	password, ok := userInfoMap[info.UserName]
	if !ok {
		fmt.Println("无法登录，找不到用户名")
		return false
	}

	if password == info.Password {
		fmt.Println("登陆成功！")
		return true
	} else {
		fmt.Println("无法登陆，密码错误")
		return false
	}
}
