#!/bin/bash
set -euo pipefail
# =========================================================
# OpenWrt DIY script part 1
# =========================================================
echo "配置 OpenClash master 主线分支..."

# 确保 feeds.conf.default 中正确写入 openclash master 源
if grep -q "src-git openclash" feeds.conf.default; then
  sed -i "s|src-git openclash.*|src-git openclash https://github.com/vernesong/OpenClash.git;master|g" feeds.conf.default
else
  echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default
fi

# 核心修正：因为当前工作目录已经是 openwrt 源码根目录，直接清理 feeds/openclash
if [ -d "feeds/openclash" ]; then
  echo "清理旧的 OpenClash feeds 缓存..."
  rm -rf feeds/openclash
fi
