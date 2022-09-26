package message

type LoginInfo struct {
	UserName string `json:"username"`
	Password string `json:"password"`
}

type RspLogin struct {
	CanLogin bool `json:"can_login"`
}
