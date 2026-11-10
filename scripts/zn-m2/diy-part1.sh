#!/bin/bash
set -euo pipefail

# =========================================================
# OpenWrt DIY script part 1 (Before Update feeds)
# =========================================================

# 1. 动态获取 OpenClash 最新 Release 标签（优先使用 GitHub Actions 的 GH_TOKEN 突破 API 限制）
echo "正在获取 OpenClash 最新 Release 标签..."
API_URL="https://api.github.com/repos/vernesong/OpenClash/releases/latest"

if [ -n "${GH_TOKEN:-}" ]; then
  LATEST_OC_TAG=$(curl -s -H "Authorization: token $GH_TOKEN" "$API_URL" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
else
  LATEST_OC_TAG=$(curl -s "$API_URL" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
fi

# 2. 如果获取成功，则直接修改 feeds.conf.default 指定对应 Tag；失败则给出警告
if [ -n "$LATEST_OC_TAG" ]; then
  echo "成功获取到 OpenClash 最新正式版标签: $LATEST_OC_TAG"
  # 替换 feeds.conf.default 中的 openclash 行，精准锁定该正式 Tag
  sed -i "s|src-git openclash.*|src-git openclash https://github.com/vernesong/OpenClash.git;$LATEST_OC_TAG|g" feeds.conf.default
else
  echo "WARNING: 获取 OpenClash 标签失败，将回退使用 default/master 配置。"
fi