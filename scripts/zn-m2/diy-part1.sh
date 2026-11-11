#!/bin/bash
set -euo pipefail
# =========================================================
# OpenWrt DIY script part 1
# 编译 OpenClash【master主线最新代码】，每次编译拉取主线最新提交
# =========================================================
echo "使用 OpenClash master 主线分支编译（最新主线版本）"

if grep -q "src-git openclash" feeds.conf.default; then
  sed -i "s|src-git openclash.*|src-git openclash https://github.com/vernesong/OpenClash.git;master|g" feeds.conf.default
else
  echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default
fi
