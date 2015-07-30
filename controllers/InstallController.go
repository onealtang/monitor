package controllers

import (
	m"monitor/models"
	"github.com/astaxie/beego"
)

type InstallController struct {
	BaseController
}



func (this *InstallController) CheckDeviceState() {
	guid := this.GetString("guid")

	beego.Debug("guid: ", guid)

	result := map[string]interface{}{}

	s2sActivelog := m.GetS2sActiveLog(guid)
	result["deviceId"] = s2sActivelog.DeviceId
	result["offerId"] = s2sActivelog.OfferId

	adunit := m.GetAdunit(s2sActivelog.OfferId)
	result["adunit"] = adunit

	this.Data["json"] = &result
	this.ServeJson()


}