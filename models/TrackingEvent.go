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

func (this *TrackingEvent) QueryEvent(cvid string, startDate time.Time, endDate time.Time) ([]TrackingEvent, int) {
	o := orm.NewOrm()

	rows := []TrackingEvent{}
	if cvid == "" {
		query := "select * from tracking_event where createDate between ? and ? limit 1000"
		o.Raw(query, startDate, endDate).QueryRows(&rows)
	} else {
		query := "select * from tracking_event where cvId = ? and createDate between ? and ? limit 1000"
		o.Raw(query, cvid, startDate, endDate).QueryRows(&rows)
	}

	return rows, len(rows)
}
