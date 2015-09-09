package models
import (
    "github.com/astaxie/beego/orm"
    "github.com/astaxie/beego"
    "time"
)


type S2sActiveLog struct {
    Id          int `orm: "column(id)"`
    DeviceId    string `orm:"size(1000);column(deviceId)"`
    OfferId     string `orm:"size(50);column(offerId)"`
    Guid        string    `orm:"size(40);column(guid)"`
    CreatedDate time.Time `orm:"column(createTime);type(datetime)"`
}

func (l *S2sActiveLog) TableName() string {
    return "s2s_activelog"
}

func (log *S2sActiveLog) GetCount() (int64, error) {
    o := orm.NewOrm()
    l := new(S2sActiveLog)
    count, err := o.QueryTable(l).Count()
    return count, err

}

func GetActiveLog(sample *S2sActiveLog) (*S2sActiveLog, error) {
    o := orm.NewOrm()
    err := o.Read(sample)
    if err != nil {
        return sample, err
    }else {
        return sample, nil
    }
}

func GetS2sActiveLog(guid string) *S2sActiveLog {
    o := orm.NewOrm()
    //	log := new(S2sActiveLog)
    //	err := o.QueryTable(log).One()
    log := S2sActiveLog{Guid: guid}
    err := o.Read(&log)
    if err != nil {
        beego.Debug("failed to get s2sActivelog", err)
    }
    return &log
}

func (this *S2sActiveLog) QueryS2sActiveLog(campaignId string, guid string, startDate time.Time, endDate time.Time) ([]S2sActiveLog, int) {

    var rows []S2sActiveLog
    o := orm.NewOrm()
    qb, _ := orm.NewQueryBuilder("mysql")
    qb.Select("*").
    From("s2s_activeLog").
    Where("createTime between ? and ?")

    if campaignId != "" {
        qb.And("offerId = ?")
    }
    if guid != "" {
        qb.And("guid = ?")
    }
    qb.OrderBy("createTime").Desc().
    Limit(1000)

//    param := struct {
//        CampaignId string
//        Guid       string
//        StartDate  time.Time
//        EndDate    time.Time
//    } {
//        CampaignId: campaignId,
//        Guid:       guid,
//        StartDate:  startDate,
//        EndDate:    endDate,
//    }

    var vals []interface{}
    vals = append(vals, startDate)
    vals = append(vals, endDate)

    if campaignId != "" {
        vals = append(vals, campaignId)
    }
    if guid != "" {
        vals = append(vals, guid)
    }

    o.Raw(qb.String(), vals).QueryRows(&rows)

    beego.Debug("Search s2s log count: ", len(rows))

    return rows, len(rows)
}