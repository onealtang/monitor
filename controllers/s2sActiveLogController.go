package controllers
import (
    "github.com/astaxie/beego"
    m "monitor/models"
    "time"
    "github.com/astaxie/beego/orm"
)


type S2sActiveLogController struct {
    beego.Controller
}

type S2sActiveLogRequest struct {
    StartDate    time.Time `form:"startDate,2006-1-2 15:04:05"`
    EndDate      time.Time `form:"endDate,2006-1-2 15:04:05"`
    ConversionId string    `form:"conversionId"`
    Guid         string    `form:"guid"`
    OfferId      string    `form:"campaignId"`
}

type S2sActiveLogResponse struct {
    OfferId      string
    Guid         string
    Url          string
    ConversionId string
    CreatedDate  time.Time
}


func (log *S2sActiveLogController) Get() {
    activeLog := new(m.S2sActiveLog)
    count, err := activeLog.GetCount()
    if err != nil {
        beego.Debug("failed to get count", err)
    } else {
        log.Data["count"] = count
    }
    log.TplNames = "s2sactivelog.tpl"
}

func (this *S2sActiveLogController) SearchS2sLog() {

    request := S2sActiveLogRequest{}
    this.ParseForm(&request)

    beego.Debug("s2s log search params:", request)

    log := &m.S2sActiveLog{}
    data, count := log.QueryS2sActiveLog(request.OfferId, request.StartDate, request.EndDate)

    allAdunit, _ := m.DefaultAdunitManager.GetAll()

    var offerCvidMap  map[string]orm.Params = make(map[string]orm.Params)
    for _, unit := range allAdunit {
        offerCvidMap[string(unit["campaignId"].(string))] = unit
    }

    resultData := []S2sActiveLogResponse{}
    if (count > 0) {
        for _, log := range data {

            resultData = append(resultData, S2sActiveLogResponse{log.OfferId, log.Guid, log.DeviceId, offerCvidMap[log.OfferId]["conversionId"].(string), log.CreatedDate})
        }
    }

    this.Data["json"] = &map[string]interface{}{"total": len(resultData), "rows": &resultData}
    this.ServeJson()

}