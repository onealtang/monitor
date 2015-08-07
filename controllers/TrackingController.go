package controllers
import (
//	"encoding/json"
	m "monitor/models"
	"time"
	"github.com/astaxie/beego"
)

type TrackingController struct {
	BaseController
}

type TrackingRequest struct {
	ConversionId	string      `form:"conversionId"`
//	Guid 			string		`form:"guid"`
	StartDate		time.Time	`form:"startDate,2006-1-2 15:04:05"`
	EndDate			time.Time	`form:"endDate,2006-1-2 15:04:05"`
}

func (this *TrackingController) QueryEvent() {
	request := TrackingRequest{}
	beego.Debug(this.Input())
	this.ParseForm(&request)

	beego.Debug("tracking request params: ", request)

	event := &m.TrackingEvent{}
	events, count := event.QueryEvent(request.ConversionId, request.StartDate, request.EndDate)
	if len(events) < 1 {
		events = []m.TrackingEvent{}
	}
	this.Data["json"] = &map[string]interface{}{"total": count, "rows": &events}
	this.ServeJson()
}