#!/bin/bash
set -euo pipefail

# =========================================================
# OpenWrt DIY script part 2 (Before Install feeds)
# =========================================================

# 1. 替换 golang 版本为 22.x（解决低版本 Go 导致 OpenClash 无法编译的问题）
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# 2. 清理其他 feeds 中可能自带的旧版 openclash，防止版本冲突
find feeds/ -maxdepth 3 -name "*openclash*" ! -path "feeds/openclash*" -exec rm -rf {} +

# 3. 刷新并安装所有 feeds，然后强制用 vernesong 的 openclash 源覆盖安装
./scripts/feeds install -a -f
./scripts/feeds install -p openclash -f luci-app-openclash
