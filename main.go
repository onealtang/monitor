package main

import (
	_ "performad_admin/routers"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"performad_admin/models"
)

func init() {
	orm.RegisterModel(new(models.S2sActiveLog))
}

func main() {
//	orm.Debug, _ = beego.AppConfig.Bool("orm.debug")
	orm.Debug = true
	beego.Run()
}

