package controllers
import (
//	"encoding/json"
	m "monitor/models"
	"github.com/astaxie/beego/orm"
	"time"
	"github.com/astaxie/beego"
)

type AdunitController struct {
	BaseController
}

type AdunitSummaryRequest struct {
	CampaignId 		string		`form:"campaignId"`
	StartDate		time.Time	`form:"startDate"`
	EndDate			time.Time	`form:"endDate"`
}

func (this *AdunitController) Get() {
	this.TplNames = "monitor/monitor.tpl"
}

func (this *AdunitController) GetAll() {

	allAdunit, _ := m.DefaultAdunitManager.GetAll()
	if len(allAdunit) < 1 {
		allAdunit = []orm.Params{}
	}
	this.Data["json"] = &allAdunit
	this.ServeJson()

}

func (this *AdunitController) QueryCampaign() {
	adunitSummary := new(AdunitSummaryRequest)
	this.ParseForm(&adunitSummary)
//	beego.Debug("start: ", this.Ctx.Input["startDate"])
//
//	adunitSummary.endDate = time.Now()
//	adunitSummary.startDate = time.Now().Add(-100*24*time.Hour)

	beego.Debug(adunitSummary)

	campaignSummaries, count := m.DefaultAdunitManager.GetCampaignCounts(adunitSummary.CampaignId, adunitSummary.StartDate, adunitSummary.EndDate)
	if len(campaignSummaries) < 1 {
		campaignSummaries = []orm.Params{}
	}
	this.Data["json"] = &map[string]interface{}{"total": count, "rows": &campaignSummaries}
	this.ServeJson()
}

func (this *AdunitController) QueryAdunit() {
	offerId := this.GetString("offerId")
	adunit := m.GetAdunit(offerId)

	this.Data["json"] = map[string]interface{}{"adunit": &adunit}
	this.ServeJson()
}