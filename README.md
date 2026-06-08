# AIC8800 SDIO Driver for OpenWrt

OpenWrt kernel module package for the **AIC8800D80** Wi-Fi 6 chipset (SDIO interface).

Targets boards like:
- Radxa Zero 3W
- Radxa Rock 3C (rev 1.4+)
- Other RK3566/RK3568 boards with onboard AIC8800D80

## Compatibility

| OpenWrt | Kernel | Target | Status |
|---------|--------|--------|--------|
| 25.12.x | 6.12   | rockchip/armv8 | ✅ Target |
| 24.10.x | 6.6    | rockchip/armv8 | Should work (untested) |

## Install on Device

```bash
# Copy the .ipk files to your OpenWrt device, then:
opkg install kmod-aic8800-sdio_*.ipk
opkg install aic8800-sdio-firmware_*.ipk

# Verify
dmesg | grep aic8800
iw dev
```

## Package Contents

- **kmod-aic8800-sdio** — Kernel modules (`aic_load_fw.ko`, `aic8800_fdrv.ko`)
- **aic8800-sdio-firmware** — Firmware files installed to `/lib/firmware/aic8800D80/`

## Source

- Driver source: [radxa-pkg/aic8800](https://github.com/radxa-pkg/aic8800) (Aicsemi SDK V5.0)
- Patches: [radxa-pkg/aic8800 debian/patches](https://github.com/radxa-pkg/aic8800/tree/main/debian/patches)
- OpenWrt packaging reference: [nickbash11/aic8800-usb_openwrt](https://github.com/nickbash11/aic8800-usb_openwrt)

## Notes

- The AIC8800 driver is **not** in the mainline Linux kernel and likely won't be merged upstream due to code quality issues.
- This is an unofficial community effort. Use at your own risk.
- Bluetooth support is not included in this package.

## License

Driver source: GPL-2.0 (as declared by Aicsemi/Radxa)
OpenWrt packaging: GPL-2.0
