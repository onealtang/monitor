package controllers
import (
//	"encoding/json"
	m "monitor/models"
	"github.com/astaxie/beego/orm"
	"time"
	"github.com/astaxie/beego"
)

type AdunitController struct {
	SecuredController
}

type AdunitSummaryRequest struct {
	CampaignId 		string		`form:"campaignId"`
	StartDate		time.Time	`form:"startDate,2006-1-2 15:04:05"`
	EndDate			time.Time	`form:"endDate,2006-1-2 15:04:05"`
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
	adunitSummary := AdunitSummaryRequest{}
	beego.Debug(this.Input())
	this.ParseForm(&adunitSummary)

	beego.Debug("request params: ", adunitSummary)

	campaignSummaries, count := m.DefaultAdunitManager.GetCampaignCounts(adunitSummary.CampaignId, adunitSummary.StartDate, adunitSummary.EndDate)
	if len(campaignSummaries) < 1 {
		campaignSummaries = []m.AdunitSummary{}
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