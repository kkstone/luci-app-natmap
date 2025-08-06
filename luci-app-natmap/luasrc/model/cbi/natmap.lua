m = Map("natmap", "NATMap",
    translate("NATMap is a port mapping tool for Fullcone-NAT (NAT-1)."))

s_status = m:section(SimpleSection)
s_status.template = "natmap_status"

s_instances = m:section(TypedSection, "instance", translate("NATMap Instances"))
s_instances.template = "cbi/tblsection"
s_instances.addremove = true
s_instances.anonymous = false

o = s_instances:option(Flag, "enabled", translate("Enabled"))
o.default = o.disabled
o.rmempty = false

o = s_instances:option(Value, "description", translate("Description"))
o.rmempty = true

o = s_instances:option(ListValue, "ip_family", translate("IP Family"))
o:value("", translate("Auto"))
o:value("4", "IPv4")
o:value("6", "IPv6")
o.default = ""
o.rmempty = true

o = s_instances:option(Value, "interface", translate("Network Interface (optional)"))
o.rmempty = true
o.placeholder = ""

o = s_instances:option(ListValue, "protocol", translate("Transport Protocol"))
o:value("tcp", translate("TCP"))
o:value("udp", translate("UDP"))
o.default = "tcp"
o.rmempty = false

o = s_instances:option(Value, "bind_port", translate("Local Bind Port"))
o.datatype = "port"
o.rmempty = false

o = s_instances:option(Value, "stun_server", translate("STUN Server"))
o.datatype = "host"
o.placeholder = ""
o.rmempty = false

o = s_instances:option(Value, "http_server", translate("HTTP Keep-alive Server"))
o.datatype = "host"
o.placeholder = ""
o.rmempty = false

o = s_instances:option(Value, "keepalive_interval", translate("Keep-alive Interval (seconds)"))
o.datatype = "uinteger"
o.rmempty = true
o.placeholder = ""

o = s_instances:option(Value, "forward_address", translate("Forward Target Address"))
o.datatype = "host"
o.rmempty = true
o.placeholder = ""

o = s_instances:option(Value, "forward_port", translate("Forward Target Port"))
o.datatype = "port"
o.rmempty = true
o.placeholder = ""

o = s_instances:option(Value, "notify_command", translate("Execute command on success (optional)"))
o.rmempty = true
o.placeholder = ""

m.on_after_commit = function(self)
    luci.sys.call("/etc/init.d/natmap restart >/dev/null 2>&1")
end

return m