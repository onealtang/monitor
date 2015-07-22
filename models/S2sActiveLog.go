package models
import "github.com/astaxie/beego/orm"


type S2sActiveLog struct {
	Id int `orm: "column(id)"`
	DeviceId string `orm:"size(1000);column(deviceId)"`
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