#!/bin/bash
set -euo pipefail

# =========================================================
# OpenWrt DIY script part 3 (After Install feeds)
# =========================================================

# 修改版本描述信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt IPQ6000 ZN-M2 (OpenClash build: $(date +%Y%m%d))'/g" package/base-files/files/etc/openwrt_release

# design 主题默认 proxy 链接指向 openclash
sed -i -r "s#navbar_proxy = 'passwall'#navbar_proxy = 'openclash'#g" feeds/luci/themes/luci-theme-design/luasrc/view/themes/design/header.htm || true

# ---------------------------------------------------------
# 修复重启/冷启动网口握手慢导致偶尔获取不到 IP 的问题
# ---------------------------------------------------------
mkdir -p package/base-files/files/etc/init.d

cat << 'EOF' > package/base-files/files/etc/init.d/network_fix
#!/bin/sh /etc/rc.common

START=99
STOP=15

start() {
    sleep 5
    ifup lan
}
EOF

chmod +x package/base-files/files/etc/init.d/network_fix
