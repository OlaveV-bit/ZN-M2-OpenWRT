#!/bin/bash
set -euo pipefail

TARGET_DIR="${FIRMWARE:-$(ls -d openwrt/bin/targets/*/* | head -n 1)}"
MANIFEST=$(ls "$TARGET_DIR"/*.manifest 2>/dev/null | head -1 || true)

OC_VER=""
if [ -n "$MANIFEST" ] && [ -f "$MANIFEST" ]; then
  OC_VER=$(grep luci-app-openclash "$MANIFEST" 2>/dev/null | awk -F" - " '{print $2}' || true)
fi

# 强行剥离版本号中的 -beta 尾缀
OC_VER=$(echo "$OC_VER" | sed 's/-beta//g')

FALLBACK_TAG="build-${GITHUB_RUN_NUMBER}"
if [ -z "$OC_VER" ]; then
  OC_VER="$FALLBACK_TAG"
fi

echo "OpenClash version: $OC_VER"
echo "OPENCLASH_VER=$OC_VER" >> "$GITHUB_ENV"
echo "release_tag=${OC_VER}" >> "$GITHUB_OUTPUT"

touch release.txt
echo "## ZN-M2 固件 (OpenClash 正式版)" > release.txt
echo "" >> release.txt
echo "**OpenClash 版本:** \`$OC_VER\`" >> release.txt
echo "" >> release.txt
echo "### 固件说明" >> release.txt
echo "- 核心内核与 luci-app-openclash 已内置" >> release.txt
echo "- 详细包信息请查看 manifest 文件" >> release.txt
echo "release_name=ZN-M2 OpenClash ${OC_VER}" >> "$GITHUB_OUTPUT"
