package main

import (
	_ "monitor/routers"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"monitor/models"
)

func init() {
	orm.RegisterModel(new(models.S2sActiveLog))
	orm.RegisterModel(new(models.Adunit))
}

func main() {
//	orm.Debug, _ = beego.AppConfig.Bool("orm.debug")
	orm.Debug = true
	beego.Run()
}

