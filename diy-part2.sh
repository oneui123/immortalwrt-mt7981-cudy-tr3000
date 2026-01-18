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

set -e

CORE_DIR="files/etc/openclash/core"
TMP_FILE="/tmp/mihomo_latest.tar.gz"

mkdir -p ${CORE_DIR}

echo "Fetching latest mihomo stable release tag..."

LATEST_TAG=$(wget -qO- https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | \
             grep '"tag_name"' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')

echo "Latest mihomo version: ${LATEST_TAG}"

DOWNLOAD_URL="https://github.com/MetaCubeX/mihomo/releases/download/${LATEST_TAG}/mihomo-linux-arm64-${LATEST_TAG}.tar.gz"

echo "Downloading: ${DOWNLOAD_URL}"

wget -qO "${TMP_FILE}" "${DOWNLOAD_URL}"

tar -zxvf "${TMP_FILE}" -C "${CORE_DIR}"

# 统一 OpenClash 识别的内核名称
if [ -f "${CORE_DIR}/mihomo" ]; then
    mv "${CORE_DIR}/mihomo" "${CORE_DIR}/clash_meta"
fi

chmod +x "${CORE_DIR}/clash_meta"
rm -f "${TMP_FILE}"

echo "mihomo stable core installed successfully."
