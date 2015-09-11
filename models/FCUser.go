package models
import (
	"crypto/md5"
    "github.com/astaxie/beego/orm"
    "errors"
    "encoding/hex"
)

type FCUser struct {
    Id          int64 `orm: "column(id)"`
    Username    string `orm:"size(30);column(username)"`
    Password    string `orm:"size(32);column(password)"`
}

func (l *FCUser) TableName() string {
    return "front_control_user"
}

func GetUserByUsername(username string) (user FCUser) {
    user = FCUser{Username: username}
    o := orm.NewOrm()
    o.Read(&user, "Username")
    return user
}

func UpdateUser(u *FCUser) (int64, error) {
//    if err := checkUser(u); err != nil {
//        return 0, err
//    }
    o := orm.NewOrm()
    user := make(orm.Params)
    if len(u.Username) > 0 {
        user["Username"] = u.Username
    }
    if len(u.Password) > 0 {
        user["Password"] = Pwdhash(u.Password)
    }
    if len(user) == 0 {
        return 0, errors.New("update field is empty")
    }
    var table FCUser
    num, err := o.QueryTable(table).Filter("Id", u.Id).Update(user)
    return num, err
}

func Pwdhash(str string) string {
    md5bytes := md5.Sum([]byte(str))
    return hex.EncodeToString(md5bytes[:])
}

// methods of structure
func CheckLogin(username string, password string) (user FCUser, err error) {
    user = GetUserByUsername(username)
    if user.Id == 0 {
        return user, errors.New("用户不存在")
    }
    if user.Password != Pwdhash(password) {
        return user, errors.New("密码错误")
    }
    return user, nil
}
