package routers

import (
	"monitor/controllers"
	"github.com/astaxie/beego"
	"github.com/beego/admin"
)

func init() {
	admin.Run()
    beego.Router("/", &controllers.MainController{})
	beego.Router("/security/index", &controllers.MainController{}, "*:Index")
	beego.Router("/security/login", &controllers.MainController{}, "*:Login")
	beego.Router("/security/logout", &controllers.MainController{}, "*:Logout")
	beego.Router("/security/changepwd", &controllers.MainController{}, "*:Changepwd")

//    beego.Router("/s2sActiveLog", &controllers.S2sActiveLogController{})
    beego.Router("/Adunit", &controllers.AdunitController{})
    beego.Router("/Admin", &controllers.AdminController{})
//    beego.Router("/Adunit/all", &controllers.AdunitController{}, "get:GetAll")
	beego.AutoRouter(&controllers.AdunitController{})
	beego.AutoRouter(&controllers.InstallController{})
	beego.AutoRouter(&controllers.S2sActiveLogController{})
	beego.AutoRouter(&controllers.TrackingController{})
}
