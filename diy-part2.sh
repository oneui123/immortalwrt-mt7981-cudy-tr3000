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

# -------- 添加 OpenClash Meta --------
mkdir -p files/etc/openclash/core

wget -qO "clash_meta.tar.gz" "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
tar -zxvf "clash_meta.tar.gz" -C files/etc/openclash/core/
mv files/etc/openclash/core/clash files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta
rm -f "clash_meta.tar.gz"

# -------- 添加 PassWall 核心 --------
# 创建存储二进制文件的目录
# BIN_DIR="$GITHUB_WORKSPACE/openwrt/files/usr/bin"
# mkdir -p "$BIN_DIR"

# -------- 下载并解压 xray-core ARM64 -------
# echo "Downloading xray-core..."
# curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.1.23/Xray-linux-arm64-v8a.zip
# unzip -o xray.zip -d "$BIN_DIR"
# chmod +x "$BIN_DIR/xray"
# rm xray.zip

# -------- 下载并解压 sing-box ARM64 -------
# echo "Downloading sing-box..."
# curl -L -o sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.12.17/sing-box-1.12.17-linux-arm64.tar.gz
# TMP_DIR=$(mktemp -d)
# tar -xzf sing-box.tar.gz -C "$TMP_DIR"
# mv "$TMP_DIR"/sing-box-1.12.17-linux-arm64/sing-box "$BIN_DIR"/sing-box
# chmod +x "$BIN_DIR/sing-box"
# rm -rf "$TMP_DIR"
# rm sing-box.tar.gz
