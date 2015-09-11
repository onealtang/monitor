package controllers

import (
	"github.com/astaxie/beego"
	m "monitor/models"
    admin_m "github.com/beego/admin/src/models"
)

type MainController struct {
	BaseController
}

func (this *MainController) Get() {
	this.Data["Website"] = "perform.onemad.com"
    this.Data["Email"] = "tangshancheng@madhouse-inc.com"
//    this.TplNames = "index.tpl"

    this.TplNames = "admin/main.tpl"

    this.LayoutSections = make(map[string]string)
    this.LayoutSections["Act_Summary"] = "admin/s2s_activelog_summary.tpl"
    this.LayoutSections["Entity_Search"] = "admin/entity_search.tpl"
    this.LayoutSections["S2s_Activelog"] = "admin/s2s_activelog.tpl"
    this.LayoutSections["Tracking_Event"] = "admin/events.tpl"
}


func (this *MainController) Index() {
	userinfo := this.GetSession("userinfo")
	if userinfo == nil {
		this.Ctx.Redirect(302, beego.AppConfig.String("rbac_auth_gateway"))
	}
	if this.IsAjax() {
		this.Data["json"] = map[string]string{"status": "1",}
		this.ServeJson()
		return
	} else {
		this.Data["userinfo"] = userinfo
//		if this.GetTemplatetype() != "easyui"{
//			this.Layout = this.GetTemplatetype() + "/admin_layout.tpl"
//		}
		this.TplNames = this.GetTemplatetype() + "/admin_layout.tpl"
	}
}

//登录
func (this *MainController) Login() {
	isajax := this.GetString("isajax")
	if isajax == "1" {
		username := this.GetString("username")
		password := this.GetString("password")
		user, err := m.CheckLogin(username, password)
		if err == nil {
            admin_user := admin_m.User{Username: user.Username, Id: user.Id,}
			this.SetSession("userinfo", admin_user)
			this.Rsp(true, "登录成功")
			return
		} else {
			this.Rsp(false, err.Error())
			return
		}
	}
	userinfo := this.GetSession("userinfo")
	if userinfo != nil {
		this.Ctx.Redirect(302, "/admin/index")
	}
	this.TplNames = this.GetTemplatetype() + "/public/login.tpl"
}

//退出
func (this *MainController) Logout() {
	this.DelSession("userinfo")
	this.Ctx.Redirect(302, "/public/login")
}

//修改密码
func (this *MainController) Changepwd() {
	userinfo := this.GetSession("userinfo")
	if userinfo == nil {
		this.Ctx.Redirect(302, beego.AppConfig.String("rbac_auth_gateway"))
	}
	oldpassword := this.GetString("oldpassword")
	newpassword := this.GetString("newpassword")
	repeatpassword := this.GetString("repeatpassword")
	if newpassword != repeatpassword {
		this.Rsp(false, "两次输入密码不一致")
	}
	user, err := m.CheckLogin(userinfo.(admin_m.User).Username, oldpassword)
	if err == nil {
		var u m.FCUser
		u.Id = user.Id
		u.Password = newpassword
		id, err := m.UpdateUser(&u)
		if err == nil && id > 0 {
			this.Rsp(true, "密码修改成功")
			return
		} else {
			this.Rsp(false, err.Error())
			return
		}
	}
	this.Rsp(false, "密码有误")

}