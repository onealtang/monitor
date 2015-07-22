package controllers
import (
	"github.com/astaxie/beego"
	m "performad_admin/models"
)


type S2sActiveLogController struct {
	beego.Controller
}


func (log *S2sActiveLogController) Get() {
	activeLog := new(m.S2sActiveLog)
	count, err := activeLog.GetCount()
	if err != nil {
		beego.Debug("failed to get count", err)
	} else {
		log.Data["count"] = count
	}
	log.TplNames = "s2sactivelog.tpl"
}