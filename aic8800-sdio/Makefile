#
# Copyright (C) 2024-2026 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=aic8800-sdio
PKG_VERSION:=5.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/radxa-pkg/aic8800.git
PKG_SOURCE_VERSION:=7f42b22913b462ab6c658dfc075bae1dbfe9a71a
PKG_SOURCE_DATE:=2026-04-29
PKG_HASH:=f7b60e51069f1f39f76a41f9196bd26815cfd08201acc16337426d75ebc27d72

PKG_MAINTAINER:=Your Name <your@email.com>
PKG_LICENSE:=GPL-2.0

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/aic8800-sdio
  SUBMENU:=Wireless Drivers
  TITLE:=AIC8800D80 Wi-Fi 6 SDIO driver
  DEPENDS:=+kmod-cfg80211 +kmod-mac80211 +kmod-mmc
  FILES:= \
	$(PKG_BUILD_DIR)/src/SDIO/driver_fw/driver/aic8800/aic8800_fdrv/aic8800_fdrv.ko \
	$(PKG_BUILD_DIR)/src/SDIO/driver_fw/driver/aic8800/aic8800_bsp/aic8800_bsp.ko
  AUTOLOAD:=$(call AutoProbe,aic8800_bsp aic8800_fdrv)
endef

define KernelPackage/aic8800-sdio/description
  Kernel module for the AIC8800D80 Wi-Fi 6 chipset (SDIO interface).
  Used on Radxa Zero 3W, Rock 3C and other boards with onboard AIC8800 Wi-Fi.
  Based on Aicsemi SDK V5.0 with patches from radxa-pkg/aic8800.
endef

define Package/aic8800-sdio-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=AIC8800D80 Wi-Fi firmware
  DEPENDS:=+kmod-aic8800-sdio
endef

define Package/aic8800-sdio-firmware/description
  Firmware files for the AIC8800D80 Wi-Fi 6 chipset (SDIO interface).
endef

EXTRA_CFLAGS += \
	-DCONFIG_AIC8800_WLAN_SUPPORT=1 \
	-DAICWF_SDIO_SUPPORT \
	-DCONFIG_USE_P2P0 \
	-DCONFIG_BACKPORTS_BUILD \
	-Wno-error

# CRITICAL: Build against backports-6.18.26 headers (same headers used to build
# cfg80211.ko/mac80211.ko), so struct wiphy layout matches cfg80211.ko
# (multi-radio fields: n_radios @ +0x520, radios @ +0x528). Kernel 6.12.94's
# cfg80211.h LACKS the multi-radio fields, so the driver's priv (rwnx_hw) lands
# at wiphy+0x520 which cfg80211.ko reads as n_radios -> wiphy_register walks the
# multi-radio path and fails wiphy_verify_iface_combinations() at core.c:642.
# NOSTDINC_FLAGS appears BEFORE LINUXINCLUDE in Kbuild's c_flags, so these -I
# paths take precedence over the kernel headers.
NOSTDINC_FLAGS = \
	$(KERNEL_NOSTDINC_FLAGS) \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-include backport/autoconf.h \
	-include backport/backport.h

MAKE_OPTS:= \
	$(KERNEL_MAKE_FLAGS) \
	M="$(PKG_BUILD_DIR)/src/SDIO/driver_fw/driver/aic8800" \
	KERNELDIR="$(LINUX_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
	CONFIG_AIC8800_BTLPM_SUPPORT=n

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

define KernelPackage/aic8800-sdio/install
	$(INSTALL_DIR) $(1)/etc/modules.d
endef

define Package/aic8800-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/aic8800_fw/SDIO/aic8800D80
	$(CP) $(PKG_BUILD_DIR)/src/SDIO/driver_fw/fw/aic8800D80/* $(1)/lib/firmware/aic8800_fw/SDIO/aic8800D80/
endef

$(eval $(call KernelPackage,aic8800-sdio))
$(eval $(call BuildPackage,aic8800-sdio-firmware))
