#!/bin/bash
set -euo pipefail

# 进入固件编译输出目录
TARGET_DIR=$(ls -d openwrt/bin/targets/*/* | head -n 1)
cd "$TARGET_DIR"

# 排除 packages 目录并设置打包环境变量
rm -rf packages
echo "FIRMWARE=$PWD" >> "$GITHUB_ENV"

mkdir -p /tmp/release-firmware

# 复制所有固件及相关文件
cp -a ./* /tmp/release-firmware/

# 删除所有带 -basic 后缀的文件
rm -f /tmp/release-firmware/*-basic*

echo "Release firmware files:"
ls -la /tmp/release-firmware/