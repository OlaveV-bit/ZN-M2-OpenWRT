#!/bin/bash
set -euo pipefail
# =========================================================
# OpenWrt DIY script part 1 (Before Update feeds)
# 加固：API异常时回退已知正式tag，不回退master
# =========================================================
echo "正在获取 OpenClash 最新正式 Release 标签..."
API_URL="https://api.github.com/repos/vernesong/OpenClash/releases/latest"
if [ -n "${GH_TOKEN:-}" ]; then
  LATEST_OC_TAG=$(curl -s -H "Authorization: token $GH_TOKEN" "$API_URL" | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/' || true)
else
  LATEST_OC_TAG=$(curl -s "$API_URL" | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/' || true)
fi

# 校验tag必须非空且以v开头，OpenClash正式版本特征
if [[ -n "$LATEST_OC_TAG" && "$LATEST_OC_TAG" =~ ^v[0-9] ]]; then
  echo "✅ 获取OpenClash最新正式tag: $LATEST_OC_TAG"
else
  # API访问失败，降级写死当前已知正式版本，拒绝master分支
  LATEST_OC_TAG="v0.48.002"
  echo "⚠️ API获取最新tag失败，降级使用硬编码正式tag: $LATEST_OC_TAG"
fi

if grep -q "src-git openclash" feeds.conf.default; then
  sed -i "s|src-git openclash.*|src-git openclash https://github.com/vernesong/OpenClash.git;$LATEST_OC_TAG|g" feeds.conf.default
else
  echo "src-git openclash https://github.com/vernesong/OpenClash.git;$LATEST_OC_TAG" >> feeds.conf.default
fi
