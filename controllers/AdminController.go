package controllers


type AdminController struct {
    SecuredController
}

func (this *AdminController) Get() {
    this.Layout = "admin/admin_layout.tpl"
    this.TplNames = "admin/main.tpl"

    this.LayoutSections = make(map[string]string)
    this.LayoutSections["Act_Summary"] = "admin/s2s_activelog_summary.tpl"
    this.LayoutSections["Entity_Search"] = "admin/entity_search.tpl"
    this.LayoutSections["S2s_Activelog"] = "admin/s2s_activelog.tpl"
    this.LayoutSections["Tracking_Event"] = "admin/events.tpl"
}