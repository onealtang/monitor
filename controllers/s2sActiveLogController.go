package controllers
import (
	"github.com/astaxie/beego"
	m "monitor/models"
	"time"
)


type S2sActiveLogController struct {
	beego.Controller
}

type S2sActiveLogRequest struct {
	StartDate time.Time `form:"startDate,2006-1-2 15:04:05"`
	EndDate	  time.Time `form:"endDate,2006-1-2 15:04:05"`
	Guid	  string    `form:"guid"`
	OfferId   string	`form:offerId`
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

func (this *S2sActiveLogController) SearchS2sLog() {

	request := S2sActiveLogRequest{}
	this.ParseForm(&request)

	beego.Debug("s2s log search params:", request)

	log := &m.S2sActiveLog{}
	data, count := log.QueryS2sActiveLog(request.OfferId, request.StartDate, request.EndDate)


	this.Data["json"] = &map[string]interface{}{"total": count, "rows": &data}
	this.ServeJson()

}