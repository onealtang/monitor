package models
import (
	"time"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego"
	"fmt"
	sql "monitor/models/sql"
)

var DefaultAdunitManager *AdUnitManager

type Adunit struct {
	Id int
	OfferId string `orm:"size(16);column(campaignId)"`
	CampaignName string `orm:"size(100);column(campaignName)"`
	StartDate time.Time `orm:"size(100);column(startDate);type(datetime)"`
	EndDate time.Time `orm:"size(100);column(endDate);type(datetime)"`
	ConversionId	string	`orm:"size(16);column(conversionId)"`
	TargetUrl		string `orm:column(targetUrl)`
}

type AdunitSummary struct {
	CampaignId 		string
	CampaignName 	string
	ReceivedCount	int64
	PostbackCount	int64
}

func (a *Adunit) TableName() string {
	return "adunit"
}


type AdUnitManager struct  {
}

func (tm *AdUnitManager) GetAll() (adunits []orm.Params, count int) {
	o := orm.NewOrm()


	_, err := o.Raw("select * from adunit where endDate").Values(&adunits)
	if err != nil {
		beego.Debug("failed to get adunits", err)
		return adunits, 0
	} else {
//		for _, v := range adunits {
//			fmt.Println(v["campaignName"])
//		}
		return adunits, len(adunits)
	}
}

func (tm *AdUnitManager) GetCampaignCounts(campaignId string, startDate time.Time, endDate time.Time) (counts []AdunitSummary, count int) {

	o := orm.NewOrm()

	var query string = ""

	query = sql.Get_Adunit_Summary
	var err error

	if campaignId != "" {
		query = query + `where a.campaignId = ?`
		_, err = o.Raw(query, startDate, endDate, startDate, endDate, campaignId).QueryRows(&counts)
	} else {
		_, err = o.Raw(query, startDate, endDate, startDate, endDate).QueryRows(&counts)
	}

	if err != nil {
		beego.Debug("failed to get counts", err)
		return counts, 0
	} else {
//		for _, v := range counts {
//			fmt.Println(v["campaignName"])
//		}
		beego.Debug(counts)
		return counts, len(counts)
	}

}

func GetAdunit(offerId string) *Adunit {
	o := orm.NewOrm()
	adunit := Adunit{OfferId: offerId}
	err := o.Read(&adunit, "OfferId")

	if err == orm.ErrNoRows {
		fmt.Println("No result found.")
	} else if err == orm.ErrMissPK {
		fmt.Println("No primary key found.")
	}
	return &adunit
}
