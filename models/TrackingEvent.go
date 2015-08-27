package models
import (
	"github.com/astaxie/beego/orm"
	"time"
)

type TrackingEvent struct {
	Id int `orm: "column(id)"`
	Guid string `orm:"size(255);column(guid)"`
	SessionId string `orm:"size(50);column(sessionId)"`
	ConversionId  string `orm:"size(50);column(cvId)"`
	Action  	string `orm:"column(action)"`
	Label		string `orm:"column(label)"`
	Value		string `orm:"column(value)"`
	UtcDate		string `orm:"column(utcDate)"`
	CreateDate	string `orm:"column(createDate)"`
}

func (this *TrackingEvent) QueryEvent(cvid string, guid string, startDate time.Time, endDate time.Time) ([]TrackingEvent, int) {
	o := orm.NewOrm()
	qb, _ := orm.NewQueryBuilder("mysql")

    var conditions []interface{}
    conditions = append(conditions, startDate)
    conditions = append(conditions, endDate)

    qb.Select("*").From("tracking_event").
    Where("createDate between ? and ?")

    if cvid != "" {
        qb.And("cvid = ?")
        conditions = append(conditions, cvid)
    }
    if guid != "" {
        qb.And("guid = ?")
        conditions = append(conditions, guid)
    }
    qb.Limit(1000)

	rows := []TrackingEvent{}
    o.Raw(qb.String(), conditions).QueryRows(&rows)

	return rows, len(rows)
}
