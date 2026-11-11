#!/bin/bash
set -euo pipefail

# =========================================================
# OpenWrt DIY script part 2 (Before Install feeds)
# =========================================================

# 1. 替换 golang 版本为 22.x（解决低版本 Go 导致 OpenClash 无法编译的问题）[cite: 20]
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# 2. 重新刷新并安装所有已知 feeds 节点[cite: 20]
./scripts/feeds install -a -f
