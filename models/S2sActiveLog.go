package models
import (
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego"
)


type S2sActiveLog struct {
	Id int `orm: "column(id)"`
	Guid 	 string	`orm:"size(40);column(guid)"`
	DeviceId string `orm:"size(1000);column(deviceId)"`
	OfferId  string	`orm:"size(100):column(offerid)"`
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