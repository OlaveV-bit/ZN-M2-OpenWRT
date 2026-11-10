#!/bin/bash
set -euo pipefail
SHOULD_BUILD=false

# 检查 OpenClash 仓库的最新 Release 标签
LATEST_OC=$(gh release list -R vernesong/OpenClash -L 1 --json tagName -q '.[0].tagName' || echo "")
LATEST_TAG=$(gh release list -R "$GITHUB_REPOSITORY" -L 1 --json tagName -q '.[0].tagName' || echo "")

if [ "$LATEST_OC" != "$LATEST_TAG" ]; then
  echo "OpenClash release: ${LATEST_TAG:-none} -> $LATEST_OC"
  SHOULD_BUILD=true
else
  echo "OpenClash release unchanged ($LATEST_TAG)"
fi

echo "should_build=$SHOULD_BUILD" >> "$GITHUB_OUTPUT"