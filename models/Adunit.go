package models
import (
	"time"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego"
	"fmt"
)

var DefaultAdunitManager *AdUnitManager

type Adunit struct {
	Id int
	OfferId string `orm:"size(16);column(campaignId)"`
	CampaignName string `orm:"size(100);column(campaignName)"`
	startDate time.Time `orm:"size(100);column(startDate);type(datetime)"`
	endDate time.Time `orm:"size(100);column(endDate);type(datetime)"`
	cvid	string	`orm:"size(16);column(conversionId)"`
}

type AdunitSummary struct {
	CampaignId 		string
	CampaignName 	string
	ReceivedCount	int
	PostbackCount	int
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

func (tm *AdUnitManager) GetCampaignCounts(campaignId string, startDate time.Time, endDate time.Time) (counts []orm.Params, count int) {

	o := orm.NewOrm()

	var query string = ""

	query = `select a.campaignId, a.campaignName, b.cnt as receivedCount, c.cnt as postbackCount from adunit a left join (
	select offerid, count(distinct(guid)) cnt from s2s_activelog
	where createTime > ? and createTime < ?
	group by offerid
	) b
	on a.campaignId = b.offerid
	left join
	(
	select campaignId, count(distinct(deviceId)) as cnt from call_postbacklog

	where createTime > ? and createTime < ?
	group by campaignId
	) c
	on a.campaignId = c.campaignId`

	var err error
	if campaignId != "" {
		query = query + `where campaignId = ?`
		_, err = o.Raw(query, startDate, endDate, startDate, endDate, campaignId).Values(&counts)
	} else {
		_, err = o.Raw(query, startDate, endDate, startDate, endDate).Values(&counts)
	}

	if err != nil {
		beego.Debug("failed to get counts", err)
		return counts, 0
	} else {
//		for _, v := range counts {
//			fmt.Println(v["campaignName"])
//		}
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
