package core

import (
	"encoding/json"
	"fmt"
	"github.com/aceld/zinx/ziface"
)

type Acount struct {
	ID   string
	Conn ziface.IConnection
}

func NewAcount(id string, conn ziface.IConnection) *Acount {

	a := &Acount{
		ID:   id,
		Conn: conn,
	}
	return a
}

func (a *Acount) SendMessage(msgID uint32, data interface{}) {
	msg, err := json.Marshal(data)
	if err != nil {
		fmt.Println("marshal msg err:", err)
		return
	}
	fmt.Printf("after Marshal data = %+v\n", msg)

	if a.Conn == nil {
		fmt.Println("connection in player is nil")
		return
	}

	//调用Zinx框架的SendMsg发包
	if err := a.Conn.SendMsg(msgID, msg); err != nil {
		fmt.Println("Player SendMsg error !")
		return
	}

	return
}
