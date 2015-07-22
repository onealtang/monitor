package controllers
import (
//	"encoding/json"
	m "performad_admin/models"
	"github.com/astaxie/beego/orm"
	"time"
	"github.com/astaxie/beego"
)

type AdunitController struct {
	BaseController
}

type AdunitSummaryRequest struct {
	campaignId 		string		`form:"campaignId"`
	startDate		time.Time	`form:"startDate"`
	endDate			time.Time	`form:"endDate"`
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
//	this.ParseForm(adunitSummary)

	adunitSummary.endDate = time.Now()
	adunitSummary.startDate = time.Now().Add(-100*24*time.Hour)

	beego.Debug(adunitSummary)

	campaignSummaries, count := m.DefaultAdunitManager.GetCampaignCounts(adunitSummary.campaignId, adunitSummary.startDate, adunitSummary.endDate)
	beego.Debug(campaignSummaries)
	if len(campaignSummaries) < 1 {
		campaignSummaries = []orm.Params{}
	}
	this.Data["json"] = &map[string]interface{}{"total": count, "rows": &campaignSummaries}
	this.ServeJson()
}