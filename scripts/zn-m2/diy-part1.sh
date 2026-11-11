#!/bin/bash
set -euo pipefail

echo "正在获取 OpenClash 最新正式 Release 标签..."
API_URL="https://api.github.com/repos/vernesong/OpenClash/releases/latest"

if [ -n "${GH_TOKEN:-}" ]; then
  LATEST_OC_TAG=$(curl -s -H "Authorization: token $GH_TOKEN" "$API_URL" | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/' || true)
else
  LATEST_OC_TAG=$(curl -s "$API_URL" | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/' || true)
fi

if [ -n "$LATEST_OC_TAG" ]; then
  echo "成功获取到 OpenClash 最新 Release 标签: $LATEST_OC_TAG"
  if grep -q "src-git openclash" feeds.conf.default; then
    sed -i "s|src-git openclash.*|src-git openclash https://github.com/vernesong/OpenClash.git;$LATEST_OC_TAG|g" feeds.conf.default
  else
    echo "src-git openclash https://github.com/vernesong/OpenClash.git;$LATEST_OC_TAG" >> feeds.conf.default
  fi
else
  echo "WARNING: 获取标签失败，将使用默认 master 分支。"
fi
