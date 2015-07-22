package routers

import (
	"performad_admin/controllers"
	"github.com/astaxie/beego"
	"github.com/beego/admin"
)

func init() {
	admin.Run()
    beego.Router("/", &controllers.MainController{})
    beego.Router("/s2sActiveLog", &controllers.S2sActiveLogController{})
    beego.Router("/Adunit", &controllers.AdunitController{})
//    beego.Router("/Adunit/all", &controllers.AdunitController{}, "get:GetAll")
	beego.AutoRouter(&controllers.AdunitController{})
}
