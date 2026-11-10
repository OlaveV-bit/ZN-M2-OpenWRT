#!/bin/bash
set -euo pipefail

# =========================================================
# OpenWrt DIY script part 2 (Before Install feeds)
# =========================================================

# 1. 替换 golang 版本为 22.x（必须在 feeds install 执行前完成，否则 OpenClash 依赖会报 Go 版本过低）
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# 2. 重新刷新并安装所有已知 feeds 节点
./scripts/feeds install -a -f