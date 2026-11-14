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

# 核心：直接在这里把 openwrt 源码目录下的 feeds/openclash 删掉
# 这样在后面执行 ./scripts/feeds update 时，它就会强制从 GitHub 克隆最新的 master 源码
if [ -d "openwrt/feeds/openclash" ]; then
  echo "清理旧的 OpenClash feeds 缓存..."
  rm -rf openwrt/feeds/openclash
fi
