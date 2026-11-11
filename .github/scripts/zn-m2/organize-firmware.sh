#!/bin/bash
set -euo pipefail

TARGET_DIR=$(ls -d openwrt/bin/targets/*/* | head -n 1)
cd "$TARGET_DIR"

rm -rf packages
echo "FIRMWARE=$PWD" >> "$GITHUB_ENV"

mkdir -p /tmp/release-firmware
cp -a ./* /tmp/release-firmware/

rm -f /tmp/release-firmware/*-basic*

echo "Release firmware files:"
ls -la /tmp/release-firmware/
