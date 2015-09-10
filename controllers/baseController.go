package controllers
import "github.com/astaxie/beego"


type BaseController struct {
	beego.Controller
}


func (base *BaseController) Prepare() {

	base.Layout = "common/layout.tpl"
	base.LayoutSections = make(map[string]string)
	base.LayoutSections["HtmlHead"] = "common/html_head.tpl"
	base.LayoutSections["Scripts"] = "common/scripts.tpl"
	base.LayoutSections["Sidebar"] = ""
}


func (this *BaseController) GetTemplatetype() string {
	templatetype := beego.AppConfig.String("template_type")
	if templatetype == "" {
		templatetype = "easyui"
	}
	return templatetype
}

func (this *BaseController) Rsp(status bool, str string) {
	this.Data["json"] = &map[string]interface{}{"status": status, "info": str}
	this.ServeJson()
}