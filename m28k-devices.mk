define Device/widora_mangopi-m28
  DEVICE_VENDOR := Widora
  SOC := rk3528
  UBOOT_DEVICE_NAME := generic-rk3528
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-aic8800-sdio wpad-openssl -urngd
endef

define Device/widora_mangopi-m28c
$(call Device/widora_mangopi-m28)
  DEVICE_MODEL := MangoPi M28C
  DEVICE_PACKAGES += kmod-usb-serial-option
endef
TARGET_DEVICES += widora_mangopi-m28c

define Device/widora_mangopi-m28k
$(call Device/widora_mangopi-m28)
  DEVICE_MODEL := MangoPi M28K
  DEVICE_PACKAGES += kmod-r8168
endef
TARGET_DEVICES += widora_mangopi-m28k

define Device/widora_mangopi-m28k-pro
$(call Device/widora_mangopi-m28)
  DEVICE_MODEL := MangoPi M28K Pro
  DEVICE_PACKAGES += kmod-i2c-gpio kmod-r8125
endef
TARGET_DEVICES += widora_mangopi-m28k-pro
