#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# add date in output file name
sed -i -e '/^IMG_PREFIX:=/i BUILD_DATE := $(shell date +%Y%m%d)' \
       -e '/^IMG_PREFIX:=/ s/\($(SUBTARGET)\)/\1-$(BUILD_DATE)/' include/image.mk

# set ubi to 122M
# sed -i 's/reg = <0x5c0000 0x7000000>;/reg = <0x5c0000 0x7a40000>;/' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts

# Add OpenClash Meta

# # # backup start
# mkdir -p files/etc/openclash/core

# wget -qO "clash_meta.tar.gz" "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
# tar -zxvf "clash_meta.tar.gz" -C files/etc/openclash/core/
# mv files/etc/openclash/core/clash files/etc/openclash/core/clash_meta
# chmod +x files/etc/openclash/core/clash_meta
# rm -f "clash_meta.tar.gz"
# # # backup end

# -------------------------------------------------------
# Add OpenClash Meta (mihomo) - Latest Stable ARM64
# -------------------------------------------------------

# 创建 OpenClash core 目录
mkdir -p files/etc/openclash/core

# 获取 mihomo 最新稳定版下载地址（ARM64）
MIHOMO_URL=$(wget -qO- https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
  | grep browser_download_url \
  | grep linux-arm64 \
  | cut -d '"' -f 4)

# 下载 mihomo
wget -qO files/etc/openclash/core/clash_meta "$MIHOMO_URL"

# 赋予执行权限
chmod +x files/etc/openclash/core/clash_meta
