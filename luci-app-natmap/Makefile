include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-natmap
PKG_VERSION:=1.0.1
PKG_RELEASE:=20250806

LUCI_TITLE:=LuCI support for NATMap
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+natmap

define Package/$(PKG_NAME)/description
  LuCI web interface for natmap, a tool for Fullcone NAT port mapping.
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/natmap
endef

include $(TOPDIR)/feeds/luci/luci.mk