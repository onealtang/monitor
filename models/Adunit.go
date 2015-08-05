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

	query = `
	SELECT a.campaignId as campaign_id,
       a.campaignName as campaign_name,
       b.cnt AS receive_count,
       c.cnt AS postback_count
	FROM   adunit a
		   LEFT JOIN (SELECT campaign,
							 Count(DISTINCT( guid )) cnt
					  FROM   conversion_rel_act_clk
					  WHERE  1 = 1
					  and time > ? and time < ?
					  GROUP  BY campaign) b
				  ON a.campaignid = b.campaign
		   LEFT JOIN (SELECT campaignid,
							 Count(DISTINCT( deviceid )) AS cnt
					  FROM   call_postbacklog
					  WHERE  1 = 1
					  and createTime > ? and createTime < ?
					  GROUP  BY campaignid) c
				  ON a.campaignid = c.campaignid
              `
	var err error

	if campaignId != "" {
		query = query + `where a.campaignId = ?`
		_, err = o.Raw(query, startDate, endDate, startDate, endDate, campaignId).QueryRows(&counts)
	} else {
//		_, err = o.Raw(query, startDate, endDate, startDate, endDate).QueryRows(&counts)
		_, err = o.Raw(query).QueryRows(&counts)
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
