module("luci.controller.natmap", package.seeall)

function index()
    entry({"admin", "services", "natmap"}, cbi("natmap"), _("NATMap"), 90).dependent = true
    entry({"admin", "services", "natmap_render_status"}, call("action_render_status"), nil)
end

function action_render_status()
    luci.template.render("natmap_status_content")
end