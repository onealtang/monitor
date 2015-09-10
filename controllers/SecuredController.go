package controllers
import "github.com/astaxie/beego"

type SecuredController struct {
    BaseController
}

func (base *SecuredController) Prepare() {
    userinfo := base.GetSession("userinfo")
    if userinfo == nil {
        base.Ctx.Redirect(302, beego.AppConfig.String("rbac_auth_gateway"))
    }
}