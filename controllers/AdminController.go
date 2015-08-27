package controllers


type AdminController struct {
    BaseController
}

func (this *AdminController) Get() {
    this.Layout = "monitor/admin_layout.tpl"
    this.TplNames = "monitor/main.tpl"

    this.LayoutSections = make(map[string]string)
    this.LayoutSections["Act_Summary"] = "monitor/s2s_activelog_summary.tpl"
    this.LayoutSections["Entity_Search"] = "monitor/entity_search.tpl"
    this.LayoutSections["S2s_Activelog"] = "monitor/s2s_activelog.tpl"
    this.LayoutSections["Tracking_Event"] = "monitor/events.tpl"
}