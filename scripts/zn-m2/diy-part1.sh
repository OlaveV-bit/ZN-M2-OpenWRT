#!/bin/bash
set -euo pipefail
# =========================================================
# OpenWrt DIY script part 1
# =========================================================
echo "配置 OpenClash master 主线分支..."

if grep -q "src-git openclash" feeds.conf.default; then
  sed -i "s|src-git openclash.*|src-git openclash https://github.com/vernesong/OpenClash.git;master|g" feeds.conf.default
else
  echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default
fi

# 关键：在这里或者在 part2 中强制 update 确保拉取最新 master
echo "正在更新并强制拉取最新 OpenClash 源码..."
./scripts/feeds update -a
./scripts/feeds install -p openclash -f
